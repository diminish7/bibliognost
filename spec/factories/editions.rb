FactoryBot.define do
  factory :edition do
    title { Faker::Book.title }
    work
  end
end
