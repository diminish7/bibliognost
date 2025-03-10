module OpenLibrary
  # Service for importing publishers from Open Library
  class PublisherService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      return false if attrs[:name].blank? || seen.include?(attrs[:name])

      seen << attrs[:name]

      true
    end

    # Override from OpenLibrary::BaseService
    def upsert_unique_by_field
      :name
    end

    def seen
      @seen ||= Set.new
    end
  end
end
