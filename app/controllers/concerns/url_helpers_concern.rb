# app/controllers/concerns/url_helpers_concern.rb
module UrlHelpersConcern
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  def path_for(img_obj)
    rails_blob_path(img_obj, only_path: true)
  end

end
