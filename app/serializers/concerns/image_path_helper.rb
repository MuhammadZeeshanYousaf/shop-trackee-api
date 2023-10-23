module ImagePathHelper
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  def path_for(img_obj)
    rails_blob_path(img_obj, only_path: true, disposition: "attachment")
  end

  def images
    if object.images.attached?
      object.images.map do |image|
        image_path = image.variant(:short).url || image.url
        { id: image.id,
          path: image_path
        }
      end
    else []
    end
  end


end
