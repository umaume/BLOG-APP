require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    subject { build(:like) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:post_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'factory' do
    it 'creates a valid like' do
      like = build(:like)
      expect(like).to be_valid
    end
  end

  describe 'uniqueness validation' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it 'prevents duplicate likes from the same user on the same post' do
      create(:like, user: user, post: post)
      duplicate_like = build(:like, user: user, post: post)

      expect(duplicate_like).not_to be_valid
      expect(duplicate_like.errors[:user_id]).to include('has already been taken')
    end

    it 'allows the same user to like different posts' do
      post2 = create(:post)
      create(:like, user: user, post: post)
      like2 = build(:like, user: user, post: post2)

      expect(like2).to be_valid
    end

    it 'allows different users to like the same post' do
      user2 = create(:user)
      create(:like, user: user, post: post)
      like2 = build(:like, user: user2, post: post)

      expect(like2).to be_valid
    end
  end
end
