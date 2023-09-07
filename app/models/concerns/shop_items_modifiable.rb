module ShopItemsModifiable
  extend ActiveSupport::Concern

  def remove_image(image_id)
    self.images.each do |image|
      if image.id == image_id
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
