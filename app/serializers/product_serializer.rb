class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :stock_quantity, :category_name, :created_at, :updated_at
  has_one :shop

end
