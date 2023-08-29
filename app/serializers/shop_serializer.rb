class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :address, :contact, :opening_time, :closing_time, :closing_days, :social_links, :shop_website_url
  has_one :seller
end
