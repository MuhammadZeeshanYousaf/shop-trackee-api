class Api::V1::FavoritesController < ApplicationController
  before_action :set_customer
  before_action :set_favoritable, only: [ :create, :destroy ]

  # POST /favorites
  def create
    if @favoritable.present?
      @favorite = @customer.favorites.new(favoritable: @favoritable)
      if @favorite.save
        render json: @favorite, serializer: FavoriteSerializer, status: :created
      else
        render json: {
          message: 'Not added to Favorite',
          error: @favorite.errors.full_messages.to_sentence
        }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Product or Service not found' }, status: :not_found
    end
  end

  # DELETE /favorites
  def destroy
    if @favoritable.present?
      @favorite = @customer.favorites.find_by favoritable: @favoritable
      if @favorite&.destroy
        render json: { message: 'Removed from Favorites successfully' }
      else
        render json: { message: 'Favorite does not exist' }, status: :not_found
      end
    end
  end


  private
    def set_customer
      @customer = current_devise_api_user.customer
      @ability.authorize! :manage, @customer
    end


    # @param [ :favoritable_type, :favoritable_id ] => required!
    def set_favoritable
      if params[:favoritable_type].present?
        @favoritable = params[:favoritable_type].camelize.constantize.find_by_id(params[:favoritable_id] )
      end
    end
end
