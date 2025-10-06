require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:post) }
    it { should validate_length_of(:body).is_at_least(1).is_at_most(1000) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'scopes' do
    let(:post) { create(:post) }
    let!(:old_comment) { create(:comment, post: post, created_at: 2.days.ago) }
    let!(:new_comment) { create(:comment, post: post, created_at: 1.day.ago) }

    describe '.recent' do
      it 'orders comments by created_at desc' do
        recent_comments = Comment.recent.limit(2)
        expect(recent_comments.first).to eq(new_comment)
        expect(recent_comments.last).to eq(old_comment)
      end
    end
  end

  describe 'factory' do
    it 'creates a valid comment' do
      comment = build(:comment)
      expect(comment).to be_valid
    end
  end

  describe 'body length validation' do
    it 'is invalid with empty body' do
      comment = build(:comment, body: '')
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("can't be blank")
    end

    it 'is invalid with body longer than 1000 characters' do
      comment = build(:comment, body: 'a' * 1001)
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include('is too long (maximum is 1000 characters)')
    end

    it 'is valid with body of 1000 characters' do
      comment = build(:comment, body: 'a' * 1000)
      expect(comment).to be_valid
    end
  end

  describe 'associations validation' do
    it 'is invalid without a user' do
      comment = build(:comment, user: nil)
      expect(comment).not_to be_valid
      expect(comment.errors[:user]).to include("must exist")
    end

    it 'is invalid without a post' do
      comment = build(:comment, post: nil)
      expect(comment).not_to be_valid
      expect(comment.errors[:post]).to include("must exist")
    end
  end
end
