class Spot < ApplicationRecord
  # == Constants ==
  ATMOSPHERE_OPTIONS = [
    "静かに過ごせる",
    "にぎやかで楽しい",
    "幻想的な雰囲気",
    "ロマンチックな空間",
    "自然を感じる"
  ].freeze

  # == Associations ==
  belongs_to :user
  belongs_to :prefecture
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # == Active Storage ==
  has_one_attached :image

  # == Virtual Attributes ==
  attr_accessor :tag_names

  # == Validations ==
  validates :name, presence: true, length: { maximum: 30 }
  validates :address, presence: true, length: { maximum: 60 }
  validates :url, format: { with: /\Ahttps?:\/\/[^\s]+\z/i, message: "は有効なURL形式でなければなりません" }, allow_blank: true
  validates :url, presence: true, length: { maximum: 255 }, if: :url_present?
  validates :body, length: { maximum: 5000 }
  validates :image, presence: true
  validate :validate_tag_limit
  validates :atmosphere, presence: true, inclusion: { in: ATMOSPHERE_OPTIONS }

  # == Callbacks ==
  after_save :assign_tags

  # == Geocoder ==
  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_address?

  # == Scopes ==
  scope :ranked_by_top_5_bookmarks, -> {
    left_joins(:bookmarks)
      .group(:id)
      .order("count(bookmarks.user_id) desc")
      .limit(5)
  }

  scope :diagnosised, -> {
    left_joins(:bookmarks)
      .group("spots.id")
      .select("spots.*, COUNT(bookmarks.id) AS bookmarks_count")
      .order("bookmarks_count DESC")
      .includes(:user, :prefecture)
      .limit(3)
  }

  # == Class Methods ==
  # == Ransack ==
  def self.ransackable_attributes(auth_object = nil)
    [ "address", "body", "name", "prefecture_id", "created_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ prefecture tags ]
  end

  # == Instance Methods ==
  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def assign_tags
    return unless tag_names

    names = tag_names.split(/[[:space:]]|　+/).map(&:strip).reject(&:blank?).uniq
    self.tags = names.map { |name| Tag.find_or_create_by(name: name) }
  end

  def full_address
    "#{prefecture.name}#{address}"
  end

  private

  # == Instance Methods ==
  def validate_tag_limit
    return unless tag_names

    names = tag_names.split(/[[:space:]]|　+/).map(&:strip).reject(&:blank?).uniq
    if names.size > 3
      errors.add(:tag_names, :too_many_tags)
    end
  end

  def url_present?
    url.present?
  end
end
