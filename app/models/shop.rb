class Shop < ApplicationRecord
  extend ArrayEnum
  array_enum closing_days: { 'Monday' => 0, 'Tuesday' => 1, 'Wednesday' => 2,
                             'Thursday' => 3, 'Friday' => 4, 'Saturday' => 5, 'Sunday' => 6 }

  default_scope { order(created_at: :desc) }
  paginates_per 6
  validates :closing_days, subset: closing_days.keys
  validates :name, uniqueness: { scope: :seller }
  # validates :latitude, :longitude, presence: true

  belongs_to :seller
  has_many :products
  has_many :services
  has_many :order_requests, dependent: :destroy


  def products_count
    products.count
  end

  def services_count
    services.count
  end

  def order_requests_count
    order_requests.count
  end

  def orders_count
    order_requests.where(status: 'accepted').count
  end

end
