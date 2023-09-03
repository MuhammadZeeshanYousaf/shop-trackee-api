class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images

  validates :name, :price, :stock_quantity, presence: true
end
