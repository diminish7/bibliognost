module OpenLibrary
  # Service for importing editions from Open Library
  class EditionService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      super && attrs[:title].present? && attrs[:work_external_identifier]
    end

    # Override from OpenLibrary::BaseService
    # Convert work external identifier and publisher names into collection of work and
    # publisher IDs
    def transform_upsert_attrs
      batch_work_ids = query_batch_work_ids
      batch_publisher_ids = query_batch_publisher_ids

      upsert_attrs.filter_map do |attrs|
        work_external_identifier = attrs.delete(:work_external_identifier)
        work_id = batch_work_ids[work_external_identifier]
        next if work_id.blank?

        attrs[:work_id] = work_id

        publisher_name = attrs.delete(:publisher_name)
        attrs[:publisher_id] = batch_publisher_ids[publisher_name]

        attrs
      end
    end

    def query_batch_work_ids
      external_identifiers = upsert_attrs.map { |attrs| attrs[:work_external_identifier] }
      Work.where(external_identifier: external_identifiers).pluck(:external_identifier, :id).to_h
    end

    def query_batch_publisher_ids
      publisher_names = upsert_attrs.map { |attrs| attrs[:publisher_name] }
      Publisher.where(name: publisher_names).pluck(:name, :id).to_h
    end
  end
end
