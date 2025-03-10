module OpenLibrary
  # Service for importing edition/subject relationships from Open Library
  class EditionAuthorService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      %i[ edition_external_identifier author_external_identifiers ].all? do |attr|
        attrs[attr].present?
      end
    end

    # Override from OpenLibrary::BaseService
    # Convert edition external identifier and author external identifiers into collection of
    # edition and Author IDs
    # Note that some may not exist because the edition or author was invalid for some reason, so
    # this filters out invalid ones as well.
    def transform_upsert_attrs
      batch_edition_ids = query_batch_edition_ids
      batch_author_ids = query_batch_author_ids

      upsert_attrs.flat_map do |attrs|
        edition_external_identifier, author_external_identifiers = attrs.values_at(
          :edition_external_identifier,
          :author_external_identifiers
        )
        edition_id = batch_edition_ids[edition_external_identifier]
        next if edition_id.nil?

        author_ids = author_external_identifiers.filter_map do |author_external_identifier|
          batch_author_ids[author_external_identifier]
        end
        next if author_ids.blank?

        author_ids.map { |author_id| { edition_id:, author_id: } }
      end.compact
    end

    # Override from OpenLibrary::BaseService
    def upsert_unique_by_field
      %i[ edition_id author_id ]
    end

    def query_batch_edition_ids
      external_identifiers = upsert_attrs.map { |attrs| attrs[:edition_external_identifier] }
      Edition.where(external_identifier: external_identifiers).pluck(:external_identifier, :id).to_h
    end

    def query_batch_author_ids
      external_identifiers = upsert_attrs.flat_map do |attrs|
        attrs[:author_external_identifiers]
      end.uniq
      Author.where(external_identifier: external_identifiers).pluck(:external_identifier, :id).to_h
    end
  end
end
