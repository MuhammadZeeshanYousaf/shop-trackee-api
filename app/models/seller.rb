class Seller < ApplicationRecord
  belongs_to :user
  has_many :shops
  has_many :products, through: :shops
  has_many :services, through: :shops
  has_many :order_requests, -> { where("removed_by != 'seller' OR removed_by IS NULL") }, through: :shops
  has_many :accepted_order_requests, -> { where(status: 'accepted') }, through: :shops, source: :order_requests


  attribute :rating, :integer
  validates :rating, numericality: { less_than_or_equal_to: 5 }

  def satisfied_customers_count
    accepted_order_requests.pluck(:customer_id).uniq.count
  end

  def total_revenue
    accepted_order_requests.map(&:orderable_price).sum
  end

end
