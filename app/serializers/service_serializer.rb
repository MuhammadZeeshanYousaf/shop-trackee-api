class ServiceSerializer < ActiveModel::Serializer
  include ImagePathHelper
  attributes :name, :description, :charge_by, :category_name, :images, :created_at, :updated_at
  has_one :shop
end
