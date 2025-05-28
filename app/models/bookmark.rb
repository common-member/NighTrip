class Bookmark < ApplicationRecord
  # == Associations ==
  belongs_to :user
  belongs_to :spot

  # == Validations ==
  validates :user_id, uniqueness: { scope: :spot_id }
end
