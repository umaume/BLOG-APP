FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    color { "##{Faker::Color.hex_color.delete('#')}" }

    trait :with_posts do
      after(:create) do |category|
        create_list(:post, 3, category: category)
      end
    end
  end
end
