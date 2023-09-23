class OrderRequestSerializer < ActiveModel::Serializer
  attributes :id, :message, :status

  has_one :orderable
  has_one :shop
  has_one :customer
end
