class Spot < ApplicationRecord
  # == Associations ==
  belongs_to :user
  belongs_to :prefecture
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # == ActiveStorage ==
  has_one_attached :image

  # == VirtualAttributes ==
  attr_accessor :tag_names

  # == Validations ==
  validates :name, presence: true, length: { maximum: 30 }
  validates :address, presence: true, length: { maximum: 60 }
  validates :url, format: { with: /\Ahttps?:\/\/[^\s]+\z/i, message: "は有効なURL形式でなければなりません" }, allow_blank: true
  validates :url, presence: true, length: { maximum: 255 }, if: :url_present?
  validates :body, length: { maximum: 5000 }
  validates :image, presence: true
  validate :validate_tag_limit

  # == Callbacks ==
  after_save :assign_tags

  # == Scopes ==
  scope :ranked_by_top_5_bookmarks, -> {
    left_joins(:bookmarks)
      .group(:id)
      .order("count(bookmarks.user_id) desc")
      .limit(5)
  }

  # == Instance Methods ==
  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  # == Ransack ==
  def self.ransackable_attributes(auth_object = nil)
    [ "address", "body", "name", "prefecture_id", "created_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ prefecture tags ]
  end

  def assign_tags
    return unless tag_names

    names = tag_names.split(/[[:space:]]|　+/).map(&:strip).reject(&:blank?).uniq
    self.tags = names.map { |name| Tag.find_or_create_by(name: name) }
  end

  private

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

  # def assign_tags
  #   return unless tag_names

  #   names = tag_names.split(/[[:space:]]|　+/).map(&:strip).reject(&:blank?).uniq
  #   if names.size > 3
  #     return
  #   end
  #   self.tags = names.map { |name| Tag.find_or_create_by(name: name) }
  # end
end
