module OpenLibrary
  # Service for importing subjects (genres and categories) from Open Library
  # NOTE: This comes from the works data dump, and so needs to be normalized
  class SubjectService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      attrs[:subjects].present?
    end

    # Override from OpenLibrary::BaseService
    # This needs to use SQL instead of Rails's upsert to avoid re-querying works
    def upsert!
      # Names come in as an array on each work record. Convert that to an array of subject records
      names = upsert_attrs.flat_map { |attrs| attrs[:subjects] }.uniq
      upsert_attrs.clear
      names.each { |name| upsert_attrs << { name: } }

      super
    end

    # Override from OpenLibrary::BaseService
    def upsert_unique_by_field
      :name
    end
  end
end
