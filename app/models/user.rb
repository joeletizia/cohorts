class User < ApplicationRecord
  scope :ordered_by_creation_date_desc, -> { order(created_at: :desc) }
  scope :ordered_by_creation_date_asc, -> { order(created_at: :asc) }
end
