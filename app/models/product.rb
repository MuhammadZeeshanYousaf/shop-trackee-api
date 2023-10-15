class Product < ApplicationRecord
  include ShopItemsModelConcern, NameSearchable
  paginates_per 6
  max_pages 100

  belongs_to :shop
  belongs_to :category
  has_many_attached :images do |attachable|
    attachable.variant :short, resize_to_limit: [250, 250]
  end
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :order_requests, as: :orderable, dependent: :destroy

  validates_presence_of :name, :price, :stock_quantity
  delegate :name, to: :category, prefix: true, allow_nil: true

  scope :stocked, -> { where('stock_quantity > ?', 0) }

end
