class UserSerializer < ActiveModel::Serializer
  include ImagePathHelper

  attributes :id, :name, :email, :gender, :country, :phone, :address, :role, :created_at, :updated_at, :avatar

  def avatar
    path_for(object.avatar.variant(:thumb)) if object.avatar.attached?
  end

end
