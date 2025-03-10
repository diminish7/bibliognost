FactoryBot.define do
  factory :language do
    sequence(:name) do |index|
      languages = OpenLibrary::LanguageService::MAPPINGS.values
      languages[index % languages.length]
    end
  end
end
