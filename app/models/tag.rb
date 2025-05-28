class Tag < ApplicationRecord
  # == Associations ==
  has_many :taggings, dependent: :destroy
  has_many :spots, through: :taggings

  # == Validations ==
  validates :name, presence: true, uniqueness: true

  # == Class Methods ==
  # == Ransack ==
  def self.ransackable_attributes(auth_object = nil)
    %w[ name ]
  end
end
