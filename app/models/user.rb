class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 100 }
  has_many :spots, dependent: :destroy

  def own?(object)
    id == object&.user.id
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name" ]
  end
end
