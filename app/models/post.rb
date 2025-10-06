class Post < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :category, optional: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many_attached :images

  # Validations
  validates :title, presence: true, length: { maximum: 200 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :slug, uniqueness: true, allow_blank: true

  # Callbacks
  before_save :generate_slug, if: :title_changed?

  # Scopes
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :search_by_content, ->(query) {
    if Rails.env.production? && ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      where('title ILIKE ? OR content ILIKE ?', "%#{query}%", "%#{query}%")
    else
      where('title LIKE ? OR content LIKE ?', "%#{query}%", "%#{query}%")
    end
  }

  # Methods
  def published?
    published == true
  end

  def draft?
    published == false
  end

  def excerpt(limit = 150)
    content.length > limit ? "#{content[0...limit]}..." : content
  end

  def liked_by?(user)
    return false unless user
    likes.exists?(user: user)
  end

  delegate :count, to: :likes, prefix: true

  def tag_names
    tags.pluck(:name).join(', ')
  end

  def tag_names=(names)
    self.tags = Tag.find_or_create_by_names(names)
  end

  def to_param
    slug.presence || id.to_s
  end

  private

  def generate_slug
    base_slug = title.parameterize
    counter = 0
    new_slug = base_slug

    while Post.where(slug: new_slug).where.not(id: id).exists?
      counter += 1
      new_slug = "#{base_slug}-#{counter}"
    end

    self.slug = new_slug
  end
end
