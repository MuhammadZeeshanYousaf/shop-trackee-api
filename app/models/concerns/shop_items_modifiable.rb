module ShopItemsModifiable
  extend ActiveSupport::Concern

  included do
    default_scope { order(created_at: :desc) }
  end

  def remove_image(image_id)
    self.images.each do |image|
      if image.id == image_id.to_i
        image.purge_later
        return true
      end
    end
    false
  end

  def get_image_key(image_id)
    self.images.each do |image|
      if image.id == image_id.to_i
        return image.key
      end
    end
    nil
  end

end
