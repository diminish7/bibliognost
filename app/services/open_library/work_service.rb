module OpenLibrary
  # Service for importing works (books, novels, novellas, short stories, poems) from Open Library
  class WorkService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      super && attrs[:title].present?
    end
  end
end
