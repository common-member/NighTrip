class Tagging < ApplicationRecord
  # == Associations ==
  belongs_to :spot
  belongs_to :tag
end
