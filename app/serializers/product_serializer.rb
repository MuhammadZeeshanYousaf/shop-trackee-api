class ProductSerializer < ActiveModel::Serializer
  include ImagePathHelper, ShopItemsSerializerConcern
  attributes :id, :name, :description, :published, :price, :stock_quantity, :category_name, :images, :created_at, :updated_at, :is_favorite

end
