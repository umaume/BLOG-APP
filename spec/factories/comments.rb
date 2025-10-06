FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraphs(number: 1).join }
    association :user
    association :post

    trait :long_comment do
      body { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    end
  end
end
