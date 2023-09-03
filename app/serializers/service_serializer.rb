class ServiceSerializer < ActiveModel::Serializer
  attributes :name, :description, :charge_by, :category_name, :created_at, :updated_at
  has_one :shop
end
