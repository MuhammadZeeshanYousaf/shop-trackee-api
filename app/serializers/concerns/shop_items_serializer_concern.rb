module ShopItemsSerializerConcern
  extend ActiveSupport::Concern

  def is_favorite
    object.favorite? instance_options[:customer_id] if instance_options[:customer_id].present?
  end

end
