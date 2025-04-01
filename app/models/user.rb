class User < ApplicationRecord
  # == External Modules ==
  # == Devise ==
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  # == Associations ==
  has_many :spots, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # == Validations ==
  validates :name, presence: true, length: { maximum: 100 }

  # == Class Methods ==
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name" ]
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  # == Instance Methods ==
  def own?(object)
    id == object&.user.id
  end
end
