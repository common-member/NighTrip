class Comment < ApplicationRecord
  # == Associations ==
  belongs_to :user
  belongs_to :spot

  # == Validations ==
  validates :body, presence: true, length: { maximum: 65_535 }
end
