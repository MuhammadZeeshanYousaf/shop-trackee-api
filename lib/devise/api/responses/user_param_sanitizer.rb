# app/lib/devise/api/responses/user_param_sanitizer.rb

class Devise::Api::Responses::UserParamSanitizer

  def self.sanitize
    yield [:name, :role_type]
  end

  def self.present
    [:id, :name, :email, :gender, :country, :phone, :address, :role_type, :created_at, :updated_at]
  end

end
