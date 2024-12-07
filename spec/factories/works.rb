FactoryBot.define do
  factory :work do
    title { Faker::Book.title }
  end
end
