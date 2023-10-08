class ServiceSerializer < ActiveModel::Serializer
  include ImagePathHelper, ShopItemsSerializerConcern
  attributes :id, :name, :description, :published, :charge_by, :rate, :category_name, :images, :created_at, :updated_at, :is_favorite

end
