class ApplicationController < ActionController::API
  before_action :authenticate_devise_api_token!
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: 'Access denied.', error: exception.message }, status: :forbidden
  end

end
