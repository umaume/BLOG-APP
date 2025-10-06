class Category < ApplicationRecord
  # Associations
  has_many :posts, dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :color, presence: true, format: { with: /\A#[0-9A-F]{6}\z/i }

  # Callbacks
  before_validation :set_default_color, if: -> { color.blank? }

  # Scopes
  scope :ordered, -> { order(:name) }

  # Methods
  def posts_count
    posts.published.count
  end

  private

  def set_default_color
    self.color = '#10B981'
  end
end
