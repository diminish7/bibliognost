RSpec.describe OpenLibrary::LanguageService, type: :service do
  subject(:service) { described_class.new }

  describe "#call" do
    it "adds all languages to the database" do
      expect { service.call }.to change(Language, :count).by(
        OpenLibrary::LanguageService::MAPPINGS.length
      )
    end
  end
end
