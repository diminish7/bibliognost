module OpenLibrary
  # Base class for services used to import initial data dumps from Open Library
  # See https://openlibrary.org/developers/dumps
  #
  # Subclasses should be named after the model they are importing, e.g.
  # `OpenLibrary::AuthorService` for importing `Author` records
  #
  # The model class should implement an `#attributes_from_open_library_json` which, given
  # a JSON object from open library data, converts it to the set of attributes used for an
  # `upsert_all` to insert the records in bulk
  #
  # Otherwise, if following naming conventions, subclasses shouldn't have to implement anything.
  class BaseService
    BATCH_SIZE = 10_000

    attr_reader :path, :errors_path, :upsert_attrs, :count

    def initialize(path)
      @path = path
      @count = 0
      @errors_path = "#{path}.errors"
      @upsert_attrs = []
    end

    def call
      Rails.logger.info "Starting #{self.class.name}..."
      each_json_object do |json_object|
        attrs = process(json_object)
        next unless valid?(attrs)

        upsert_attrs << attrs
        # Upsert the batch if we've reached the batch size (and reset the attrs collection)
        upsert_and_clear! if upsert_attrs.length >= BATCH_SIZE
      end
      # Upsert the last batch if any
      upsert! if upsert_attrs.present?
      Rails.logger.info "Processed #{count} #{model_name} records."
    end

    private

    def model_class
      @model_class ||= self.class.name.demodulize.delete_suffix("Service").constantize
    end

    def model_name
      model_class.model_name.human
    end

    def process(json_object)
      model_class.attributes_from_open_library_json(json_object)
    end

    # Override in subclasses if there are any other validations
    def valid?(attrs)
      attrs[:external_identifier].present?
    end

    def each_json_object
      File.open(path, "r").each_line do |line|
        # Open Library dumps are tab-delimited columns for type, key, revision, last_modified, json
        # All other columns are included in the JSON, so we are only grabbing the last column.
        yield JSON.parse(line.split("\t").last)
        @count += 1
      rescue StandardError => e
        Rails.logger.error(e.message)
        File.open(errors_path, "w") { |f| f.write("#{line}\t#{e.class.name} - #{e.message}") }
      end
    end

    def upsert_and_clear!
      upsert!
      upsert_attrs.clear
    end

    def upsert!
      final_upsert_attrs = transform_upsert_attrs
      Rails.logger.info "Upserting #{final_upsert_attrs.length} #{model_name} records."
      model_class.upsert_all(final_upsert_attrs, unique_by: upsert_unique_by_field, returning: false)
    end

    # By default, this just returns the upsert attrs we've been collecting for the batch, but
    # this can be overridden in subclasses to apply transformations if needed
    def transform_upsert_attrs
      upsert_attrs
    end

    def upsert_unique_by_field
      :external_identifier
    end

    def connection
      ActiveRecord::Base.connection
    end

    def quote(val)
      connection.quote(val)
    end
  end
end
