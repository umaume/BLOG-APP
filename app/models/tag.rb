class Tag < ApplicationRecord
  # Associations
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  # Validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :color, presence: true, format: { with: /\A#[0-9A-F]{6}\z/i }

  # Callbacks
  before_validation :set_default_color, if: -> { color.blank? }
  before_validation :normalize_name

  # Scopes
  scope :ordered, -> { order(:name) }
  scope :popular, -> { joins(:posts).group('tags.id').order('COUNT(posts.id) DESC') }

  # Methods
  def posts_count
    posts.published.count
  end

  def self.find_or_create_by_names(tag_names)
    return [] if tag_names.blank?

    names = tag_names.split(',').map(&:strip).compact_blank.uniq
    names.map do |name|
      find_or_create_by(name: name)
    end
  end

  private

  def set_default_color
    self.color = '#3B82F6'
  end

  def normalize_name
    self.name = name.strip.downcase if name.present?
  end
end
