class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :stock_quantity, :created_at, :updated_at
  has_one :category
  has_one :shop
end
