class ProductSerializer < ActiveModel::Serializer
  include ImagePathHelper
  attributes :id, :name, :description, :price, :stock_quantity, :category_name, :images, :created_at, :updated_at
  has_one :shop

  def images
    if object.images.attached?
      object.images.map do |image|
        { id: image.id,
          path: path_for(image)
        }
      end
    else []
    end
  end

end
