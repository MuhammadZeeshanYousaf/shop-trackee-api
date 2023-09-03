class ServiceSerializer < ActiveModel::Serializer
  attributes :name, :description, :charge_by, :created_at, :updated_at
  has_one :category
  has_one :shop
end
