class Product < ApplicationRecord
  include ShopItemsModifiable
  belongs_to :shop
  belongs_to :category
  has_many_attached :images
  has_many :favorites, as: :favoritable

  validates_presence_of :name, :price, :stock_quantity
  delegate :name, to: :category, prefix: true, allow_nil: true
end
