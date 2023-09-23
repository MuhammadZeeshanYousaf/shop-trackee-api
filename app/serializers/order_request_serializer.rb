class OrderRequestSerializer < ActiveModel::Serializer
  attributes :id, :message, :status, :created_at, :orderable_type

  has_one :orderable
  has_one :shop
  has_one :customer

  def created_at
    object.created_at.strftime("%a, %d %b %Y%l:%M %p")
  end

end
