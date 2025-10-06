require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:user) }
    it { should validate_length_of(:title).is_at_most(200) }
    it { should validate_length_of(:content).is_at_least(10) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category).optional }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:liked_users).through(:likes).source(:user) }
    it { should have_many(:post_tags).dependent(:destroy) }
    it { should have_many(:tags).through(:post_tags) }
    it { should have_many_attached(:images) }
  end

  describe 'scopes' do
    let!(:published_posts) { create_list(:post, 2, published: true) }
    let!(:draft_posts) { create_list(:post, 3, published: false) }

    describe '.published' do
      it 'returns only published posts' do
        expect(Post.published).to match_array(published_posts)
      end
    end

    describe '.draft' do
      it 'returns only draft posts' do
        expect(Post.draft).to match_array(draft_posts)
      end
    end

    describe '.recent' do
      it 'orders posts by created_at desc' do
        posts = Post.recent.limit(2)
        expect(posts.first.created_at).to be >= posts.last.created_at
      end
    end
  end

  describe 'factory' do
    it 'creates a valid post' do
      post = build(:post)
      expect(post).to be_valid
    end
  end

  describe '#published?' do
    it 'returns true for published posts' do
      post = build(:post, published: true)
      expect(post.published?).to be_truthy
    end

    it 'returns false for draft posts' do
      post = build(:post, published: false)
      expect(post.published?).to be_falsey
    end
  end

  describe '#draft?' do
    it 'returns true for draft posts' do
      post = build(:post, published: false)
      expect(post.draft?).to be_truthy
    end

    it 'returns false for published posts' do
      post = build(:post, published: true)
      expect(post.draft?).to be_falsey
    end
  end

  describe '#excerpt' do
    it 'returns a truncated version of content' do
      long_content = 'a' * 200
      post = build(:post, content: long_content)
      excerpt = post.excerpt(100)

      expect(excerpt.length).to be <= 103 # 100 + '...'
      expect(excerpt).to end_with('...')
    end

    it 'returns full content if shorter than limit' do
      short_content = 'Short content'
      post = build(:post, content: short_content)

      expect(post.excerpt(100)).to eq(short_content)
    end
  end

  describe '#liked_by?' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }

    context 'when user has liked the post' do
      before { create(:like, user: user, post: post) }

      it 'returns true' do
        expect(post.liked_by?(user)).to be_truthy
      end
    end

    context 'when user has not liked the post' do
      it 'returns false' do
        expect(post.liked_by?(user)).to be_falsey
      end
    end
  end

  describe '#likes_count' do
    it 'returns the number of likes' do
      post = create(:post, :with_likes)
      expect(post.likes_count).to eq(2)
    end
  end

  describe '.search_by_content' do
    let!(:post1) { create(:post, title: 'Ruby on Rails', content: 'Learning Rails') }
    let!(:post2) { create(:post, title: 'JavaScript Guide', content: 'Advanced JavaScript') }
    let!(:post3) { create(:post, title: 'Rails Testing', content: 'Testing with RSpec') }

    it 'finds posts by title' do
      results = Post.search_by_content('Rails')
      expect(results).to include(post1, post3)
      expect(results).not_to include(post2)
    end

    it 'finds posts by content' do
      results = Post.search_by_content('JavaScript')
      expect(results).to include(post2)
      expect(results).not_to include(post1, post3)
    end

    it 'is case insensitive' do
      results = Post.search_by_content('rails')
      expect(results).to include(post1, post3)
    end
  end

  describe '#tag_names=' do
    let(:post) { create(:post) }

    it 'creates new tags and associates them with the post' do
      post.tag_names = 'ruby, rails, programming'

      expect(post.tags.map(&:name)).to match_array([ 'ruby', 'rails', 'programming' ])
    end

    it 'uses existing tags if they already exist' do
      existing_tag = create(:tag, name: 'ruby')
      post.tag_names = 'ruby, rails'

      expect(post.tags).to include(existing_tag)
      expect(post.tags.count).to eq(2)
    end
  end

  describe '#to_param' do
    context 'when post has a slug' do
      it 'returns the slug' do
        post = create(:post)
        post.update(slug: 'test-slug')
        expect(post.to_param).to eq('test-slug')
      end
    end

    context 'when post has no slug' do
      it 'returns the id' do
        post = create(:post)
        post.update(slug: nil)
        expect(post.to_param).to eq(post.id.to_s)
      end
    end
  end
end
