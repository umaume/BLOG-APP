FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence(word_count: 5) }
    content { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    published { true }
    association :user
    association :category

    trait :draft do
      published { false }
    end

    trait :with_tags do
      after(:create) do |post|
        create_list(:tag, 2).each do |tag|
          post.tags << tag
        end
      end
    end

    trait :with_images do
      after(:build) do |post|
        2.times do |i|
          post.images.attach(
            io: StringIO.new("fake image data #{i}"),
            filename: "image#{i}.jpg",
            content_type: "image/jpeg"
          )
        end
      end
    end

    trait :with_comments do
      after(:create) do |post|
        create_list(:comment, 3, post: post)
      end
    end

    trait :with_likes do
      after(:create) do |post|
        create_list(:like, 2, post: post)
      end
    end
  end
end
