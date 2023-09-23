class Product < ApplicationRecord
  include ShopItemsModifiable
  include NameSearchable

  belongs_to :shop
  belongs_to :category
  has_many_attached :images
  has_many :favorites, as: :favoritable
  has_many :order_requests, as: :orderable

  validates_presence_of :name, :price, :stock_quantity
  delegate :name, to: :category, prefix: true, allow_nil: true
end
