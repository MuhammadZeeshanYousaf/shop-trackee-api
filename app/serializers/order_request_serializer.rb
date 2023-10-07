class OrderRequestSerializer < ActiveModel::Serializer
  attributes :id, :message, :status, :created_at, :orderable_type, :customer

  has_one :orderable
  has_one :shop

  def created_at
    object.created_at.strftime("%a, %d %b %Y%l:%M %p")
  end

  def customer
    @customer = object.customer
    @user = @customer.user

    @user.serializable_hash(only: [:name, :email, :phone, :address, :gender]).merge(@customer.serializable_hash)
  end

end
