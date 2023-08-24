# app/lib/devise/api/responses/user_param_sanitizer.rb
# Note: role will be automatically fetched

class Devise::Api::Responses::UserParamSanitizer

  def self.sanitize
    yield :name
  end

  def self.present
    [:id, :name, :email, :created_at, :updated_at]
  end

end
