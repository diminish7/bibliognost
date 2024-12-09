module OpenLibrary
  # Service for importing work/subject relationships from Open Library
  class WorkAuthorService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      %i[ work_external_identifier author_external_identifiers ].all? do |attr|
        attrs[attr].present?
      end
    end

    # Override from OpenLibrary::BaseService
    # Convert work external identifier and author external identifiers into collection of work and
    # Author IDs
    # Note that some may not exist because the work or author was invalid for some reason, so
    # this filters out invalid ones as well.
    def transform_upsert_attrs
      batch_work_ids = query_batch_work_ids
      batch_author_ids = query_batch_author_ids

      upsert_attrs.flat_map do |attrs|
        work_external_identifier, author_external_identifiers = attrs.values_at(
          :work_external_identifier,
          :author_external_identifiers
        )
        work_id = batch_work_ids[work_external_identifier]
        next if work_id.nil?

        author_ids = author_external_identifiers.filter_map do |author_external_identifier|
          batch_author_ids[author_external_identifier]
        end
        next if author_ids.blank?

        author_ids.map { |author_id| { work_id:, author_id: } }
      end.compact
    end

    # Override from OpenLibrary::BaseService
    def upsert_unique_by_field
      %i[ work_id author_id ]
    end

    def query_batch_work_ids
      external_identifiers = upsert_attrs.map { |attrs| attrs[:work_external_identifier] }
      Work.where(external_identifier: external_identifiers).pluck(:external_identifier, :id).to_h
    end

    def query_batch_author_ids
      external_identifiers = upsert_attrs.flat_map do |attrs|
        attrs[:author_external_identifiers]
      end.uniq
      Author.where(external_identifier: external_identifiers).pluck(:external_identifier, :id).to_h
    end
  end
end
