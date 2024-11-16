module OpenLibrary
  # Service for importing author records from Open Library
  class AuthorService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      super && attrs[:name].present?
    end
  end
end
