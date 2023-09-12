class FavoriteSerializer < ActiveModel::Serializer
  attributes :id
  has_one :favoritable
end
