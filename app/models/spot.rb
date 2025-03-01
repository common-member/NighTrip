class Spot < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture

  has_one_attached :image

  validates :name, presence: true
  validates :address, presence: true
  validates :url, format: { with: /\Ahttps?:\/\/[^\s]+\z/i, message: "は有効なURL形式でなければなりません" }, allow_blank: true
  validates :url, presence: true, if: :url_present?
  validates :body, length: { maximum: 5000 }
  validates :image, presence: true

  private

  def url_present?
    url.present?
  end

  def self.ransackable_attributes(auth_object = nil)
    ["address", "body", "name", "prefecture_id", "updated_at", "user_id", "use.name"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "prefecture"]
  end

  # ransacker :user_name, formatter: proc { |v| User.where("name LIKE ?", "%#{v}%").pluck(:id) } do |parent|
  #   parent.table[:user_id]
  # end
end
