FactoryBot.define do
  factory :like do
    association :user
    association :post

    # Avoid duplicate likes for the same user and post
    initialize_with { Like.find_or_create_by(user: user, post: post) }
  end
end
