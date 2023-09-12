class Favorite < ApplicationRecord
  belongs_to :customer
  belongs_to :favoritable, polymorphic: true

end
