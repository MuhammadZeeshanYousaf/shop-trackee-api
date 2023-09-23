class FavoriteSerializer < ActiveModel::Serializer
  attributes :id, :favoritable_type
  has_one :favoritable
end
