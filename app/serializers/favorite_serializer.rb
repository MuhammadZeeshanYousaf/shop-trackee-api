class FavoriteSerializer < ActiveModel::Serializer
  attributes :id, :favoritable_type
  has_one :favoritable

  def favoritable
    ActiveModelSerializers::SerializableResource.new(object.favoritable).serializable_hash.merge(is_favorite: true)
  end

end
