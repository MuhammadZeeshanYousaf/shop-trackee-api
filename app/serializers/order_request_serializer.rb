class OrderRequestSerializer < ActiveModel::Serializer
  attributes :id, :message, :status, :created_at

  has_one :orderable
  has_one :shop
  has_one :customer
end
