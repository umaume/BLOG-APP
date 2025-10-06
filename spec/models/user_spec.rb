require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:liked_posts).through(:likes).source(:post) }
    it { should have_one_attached(:avatar) }
  end

  describe 'factory' do
    it 'creates a valid user' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe '#display_name' do
    it 'returns the name when present' do
      user = build(:user, name: 'John Doe')
      expect(user.display_name).to eq('John Doe')
    end

    it 'returns email when name is blank' do
      user = build(:user, name: '', email: 'john@example.com')
      expect(user.display_name).to eq('john@example.com')
    end
  end

  describe '#avatar_thumbnail' do
    context 'when avatar is attached' do
      it 'returns the variant' do
        user = create(:user, :with_avatar)
        expect(user.avatar_thumbnail(100)).to be_present
      end
    end

    context 'when no avatar is attached' do
      it 'returns nil' do
        user = create(:user)
        expect(user.avatar_thumbnail(100)).to be_nil
      end
    end
  end

  describe '#posts_count' do
    it 'returns the count of published posts' do
      user = create(:user)
      create_list(:post, 3, user: user, published: true)
      create(:post, user: user, published: false) # draft post

      expect(user.posts_count).to eq(3)
    end
  end

  describe '#liked?' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    context 'when user has liked the post' do
      before { create(:like, user: user, post: post) }

      it 'returns true' do
        expect(user.liked?(post)).to be_truthy
      end
    end

    context 'when user has not liked the post' do
      it 'returns false' do
        expect(user.liked?(post)).to be_falsey
      end
    end
  end
end
