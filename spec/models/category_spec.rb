require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    subject { build(:category) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:color) }
  end

  describe 'associations' do
    it { should have_many(:posts) }
  end

  describe 'scopes' do
    let!(:category_a) { create(:category, name: 'A Category') }
    let!(:category_z) { create(:category, name: 'Z Category') }
    let!(:category_b) { create(:category, name: 'B Category') }

    describe '.ordered' do
      it 'orders categories by name' do
        ordered_categories = Category.ordered
        expect(ordered_categories.pluck(:name)).to eq([ 'A Category', 'B Category', 'Z Category' ])
      end
    end
  end

  describe 'factory' do
    it 'creates a valid category' do
      category = build(:category)
      expect(category).to be_valid
    end
  end

  describe '#posts_count' do
    let(:category) { create(:category) }

    it 'returns the number of published posts in the category' do
      create_list(:post, 3, category: category, published: true)
      create(:post, category: category, published: false) # draft post

      expect(category.posts_count).to eq(3)
    end
  end
end
