module OpenLibrary
  # Service for importing edition covers from Open Library
  class EditionCoverService < BaseCoverService
    private

    def parent_model
      Edition
    end
  end
end
