class UserSerializer < ActiveModel::Serializer
  include ImagePathHelper

  attributes :id, :name, :email, :gender, :country, :phone, :address, :role, :created_at, :updated_at, :avatar

  def avatar
    object.avatar.variant(:thumb).url || object.avatar.url if object.avatar.attached?
  end

end
