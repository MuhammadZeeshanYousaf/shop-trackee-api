class ServiceSerializer < ActiveModel::Serializer
  include ImagePathHelper
  attributes :id, :name, :description, :published, :charge_by, :rate, :category_name, :images, :created_at, :updated_at
  has_one :shop
end
