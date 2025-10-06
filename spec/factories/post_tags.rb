FactoryBot.define do
  factory :post_tag do
    association :post
    association :tag

    # Avoid duplicate associations
    initialize_with { PostTag.find_or_create_by(post: post, tag: tag) }
  end
end
