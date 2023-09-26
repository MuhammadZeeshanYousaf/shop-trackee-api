class Seller < ApplicationRecord
  belongs_to :user
  has_many :shops
  has_many :products, through: :shops
  has_many :services, through: :shops
  has_many :order_requests, -> { where("removed_by != 'seller' OR removed_by IS NULL") }, through: :shops

  attribute :rating, :integer
  validates :rating, numericality: { less_than_or_equal_to: 5 }

end
