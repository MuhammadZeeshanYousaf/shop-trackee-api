class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :address, :contact, :opening_time, :closing_time, :closing_days, :social_links, :shop_website_url
  has_one :seller

  def opening_time
    object.opening_time&.strftime(DATETIME_FORMAT)
  end

  def closing_time
    object.closing_time&.strftime(DATETIME_FORMAT)
  end

end
