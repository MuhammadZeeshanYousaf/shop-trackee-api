class Seller < ApplicationRecord
  belongs_to :user

  attribute :rating, :integer
  validates :rating, numericality: { less_than_or_equal_to: 5 }

end
