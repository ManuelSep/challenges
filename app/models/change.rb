class Change < ApplicationRecord
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :field, presence: true
  validates :changed_at, presence: true
end
