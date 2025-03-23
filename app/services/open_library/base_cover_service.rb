module OpenLibrary
  # Abstract base service for importing covers from Open Library
  class BaseCoverService < BaseService
    private

    # Abstract method to be overridden in subclasses. Represents the model class
    # for the parent model (i.e. the model that the cover will be attached to)
    def parent_model
      raise NotImplementedError
    end

    # Override from OpenLibrary::BaseService
    def model_name
      "Cover"
    end

    # Override from OpenLibrary::BaseService
    def process(json_object)
      external_identifier, covers = json_object.values_at("key", "covers")

      { external_identifier:, covers: covers&.compact }
    end

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      super && attrs[:covers].present?
    end

    # Override from OpenLibrary::BaseService
    # NOTE: We aren't actually doing an upsert here because we're attaching a file, so this
    # is just a bunch of individual insert queries.
    def upsert!
      batch_parents = query_batch_parent_ids

      Rails.logger.info "Attaching #{upsert_attrs.length} covers."
      upsert_attrs.each do |attrs|
        parent = batch_parents[attrs[:external_identifier]]
        next if parent.nil?

        attrs[:covers].each do |cover_id|
          attach!(parent, cover_id)
        end
      end
    end

    def attach!(parent, cover_id)
      # Infer the filename and path from the cover ID:
      cover_string = "%010d" % cover_id
      # Directories are broken up by the first digit of the cover ID
      level1_dir = "m_covers_#{cover_string.slice(0..3)}"
      # Then subfolder by the next two digits of the cover ID
      level2_dir = cover_string.slice(4..5)
      # Then the file name based on the cover ID with leading zeroes
      filename = "#{cover_string}-M.jpg"
      return if already_attached?(parent, filename)

      path = Rails.root.join("db/dumps/covers", level1_dir, level2_dir, filename)
      return unless File.exist?(path)

      parent.covers.attach(io: File.open(path), filename:)
    end

    def already_attached?(parent, filename)
      parent.covers.any? do |cover|
        cover.filename == filename
      end
    end

    def query_batch_parent_ids
      parent_model.where(
        external_identifier: upsert_attrs.map { |attrs| attrs[:external_identifier] }
      ).preload(covers_attachments: :blob).index_by(&:external_identifier)
    end
  end
end
