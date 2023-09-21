class ApplicationController < ActionController::API
  before_action :authenticate_devise_api_token!, prepend: true
  before_action :set_ability
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: 'Access denied.', error: exception.message }, status: :unauthorized
  end


  protected
    def set_ability
      @ability = Ability.new(current_devise_api_user)
    end

end
