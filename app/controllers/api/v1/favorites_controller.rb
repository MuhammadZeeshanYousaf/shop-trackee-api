class Api::V1::FavoritesController < ApplicationController
  before_action :set_customer
  before_action :set_favoritable, only: [ :create ]

  # POST /favorites
  def create
    if @customer.present? && @favoritable.present?
      @favorite = @customer.favorites.new(favoritable: @favoritable)
      if @favorite.save
        render json: @favorite, serializer: FavoriteSerializer, status: :created
      else
        render json: {
          message: 'Favorite not added',
          error: @favorite.errors.full_messages.to_sentence
        }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Product or Service not found' }, status: :not_found
    end
  end


  private
    def set_customer
      @customer = current_devise_api_user.customer
    end


    # @param [ :favoritable_type, :favoritable_id ] => required!
    def set_favoritable
      if params[:favoritable_type].present?
        @favoritable = params[:favoritable_type].camelize.constantize.find_by_id(params[:favoritable_id] )
      end
    end
end
