class Spot < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture

  validates :name, presence: true
  validates :address, presence: true
  validates :url, format: { with: URI.regexp(%w[http https]), message: "は有効なURL形式でなければなりません" }, allow_blank: true
end
