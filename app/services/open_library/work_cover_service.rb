module OpenLibrary
  # Service for importing work covers from Open Library
  class WorkCoverService < BaseCoverService
    private

    def parent_model
      Work
    end
  end
end
