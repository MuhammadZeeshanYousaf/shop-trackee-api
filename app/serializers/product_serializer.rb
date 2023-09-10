class ProductSerializer < ActiveModel::Serializer
  include ImagePathHelper
  attributes :id, :name, :description, :published, :price, :stock_quantity, :category_name, :images, :created_at, :updated_at
  has_one :shop
end
