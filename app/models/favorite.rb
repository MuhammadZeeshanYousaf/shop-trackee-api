class Favorite < ApplicationRecord
  default_scope { order(created_at: :desc) }
  paginates_per 6

  belongs_to :customer
  belongs_to :favoritable, polymorphic: true

end
