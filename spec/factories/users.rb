FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "Test User #{n}" }
    password { "password123" }
    password_confirmation { "password123" }
    bio { "Test bio for this user" }
    website { "https://example.com" }

    trait :with_avatar do
      after(:build) do |user|
        user.avatar.attach(
          io: StringIO.new("fake image data"),
          filename: "avatar.jpg",
          content_type: "image/jpeg"
        )
      end
    end
  end
end
