FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag#{n}" }
    color { "##{Faker::Color.hex_color.delete('#')}" }

    trait :popular do
      after(:create) do |tag|
        create_list(:post_tag, 5, tag: tag)
      end
    end
  end
end
