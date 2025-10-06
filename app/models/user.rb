class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  # Follow associations
  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_follows, class_name: 'Follow', foreign_key: 'following_id', dependent: :destroy
  has_many :following, through: :active_follows, source: :following
  has_many :followers, through: :passive_follows, source: :follower

  has_one_attached :avatar

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :bio, length: { maximum: 500 }
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL' }, allow_blank: true

  # Methods
  def display_name
    (name.presence || email.split('@').first)
  end

  def avatar_thumbnail(size = 200)
    return unless avatar.attached?
    avatar.variant(resize_to_limit: [ size, size ])
  end

  # Follow methods
  def follow(other_user)
    return false if self == other_user
    active_follows.create(following: other_user)
  end

  def unfollow(other_user)
    active_follows.find_by(following: other_user)&.destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  delegate :count, to: :followers, prefix: true

  delegate :count, to: :following, prefix: true

  def posts_count
    posts.published.count
  end

  def liked?(post)
    likes.exists?(post: post)
  end
end
