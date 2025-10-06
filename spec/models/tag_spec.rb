require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'validations' do
    subject { build(:tag) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:color) }
  end

  describe 'associations' do
    it { should have_many(:post_tags).dependent(:destroy) }
    it { should have_many(:posts).through(:post_tags) }
  end

  describe 'scopes' do
    let!(:popular_tag) { create(:tag) }
    let!(:unpopular_tag) { create(:tag) }

    before do
      # Create posts with tags to make one popular
      create_list(:post_tag, 5, tag: popular_tag)
      create(:post_tag, tag: unpopular_tag)
    end

    describe '.popular' do
      it 'orders tags by post count' do
        popular_tags = Tag.popular.limit(2)
        expect(popular_tags.first).to eq(popular_tag)
      end
    end
  end

  describe 'factory' do
    it 'creates a valid tag' do
      tag = build(:tag)
      expect(tag).to be_valid
    end
  end

  describe '#posts_count' do
    let(:tag) { create(:tag) }

    it 'returns the number of published posts with this tag' do
      published_posts = create_list(:post, 3, published: true)
      draft_post = create(:post, published: false)

      published_posts.each { |post| post.tags << tag }
      draft_post.tags << tag

      expect(tag.posts_count).to eq(3)
    end
  end
end
