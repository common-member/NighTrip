class Spot < ApplicationRecord
  # == Associations ==
  belongs_to :user
  belongs_to :prefecture
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # == ActiveStorage ==
  has_one_attached :image

  # == Validations ==
  validates :name, presence: true, length: { maximum: 30 }
  validates :address, presence: true
  validates :url, format: { with: /\Ahttps?:\/\/[^\s]+\z/i, message: "は有効なURL形式でなければなりません" }, allow_blank: true
  validates :url, presence: true, if: :url_present?
  validates :body, length: { maximum: 5000 }
  validates :image, presence: true

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
    [ "prefecture" ]
  end

  private

  def url_present?
    url.present?
  end
end
