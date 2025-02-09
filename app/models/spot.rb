class Spot < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture

  has_one_attached :image

  validates :name, presence: true
  validates :address, presence: true
  validates :url, format: { with: URI.regexp(%w[http https]), message: "は有効なURL形式でなければなりません" }, allow_blank: true
  validates :body, length: { maximum: 5000 }
  validates :image, presence: true
end
