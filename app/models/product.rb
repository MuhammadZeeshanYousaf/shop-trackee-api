class Product < ApplicationRecord
  belongs_to :shop
  belongs_to :category
  has_many_attached :images

  validates :name, :price, :stock_quantity, presence: true
  delegate :name, to: :category, prefix: true
end
