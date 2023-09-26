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
        { id: image.id,
          path: path_for(image.variant(:short))
        }
      end
    else []
    end
  end


end
