class Api::V1::FavoritesController < ApplicationController
  before_action :set_customer
  before_action :set_favoritable, only: [ :create, :destroy, :update ]

  def index
    render json: @customer.favorites, each_serializer: FavoriteSerializer
  end

  # PUT /favorites
  def update
    is_favorite = params[:is_favorite]

    if @favoritable.present?
      @favorite = @customer.favorites.find_or_initialize_by favoritable: @favoritable

      if is_favorite.to_s.downcase.eql? true.to_s
        if @favorite.save
          render json: { message: "#{@favorite.favoritable_type} added to favorites", favorite: FavoriteSerializer.new(@favorite).serializable_hash }, status: :created
        else
          render json: {
            message: "#{params[:favoritable_type]} not added to Favorite",
            error: @favorite.errors.full_messages.to_sentence
          }, status: :unprocessable_entity
        end

      elsif is_favorite.to_s.downcase.eql? false.to_s
        if @favorite&.destroy
          render json: { message: "#{@favorite.favoritable_type} removed from favorites" }
        else
          render json: { message: 'Favorite not found' }, status: :not_found
        end

      else head :bad_request
      end
    else
      render json: { message: 'Favoritable product or service not found' }, status: :not_found
    end
  end

  # POST /favorites
  def create
    if @favoritable.present?
      @favorite = @customer.favorites.new(favoritable: @favoritable)
      if @favorite.save
        render json: { message: "#{@favorite.favoritable_type} added to favorites", favorite: FavoriteSerializer.new(@favorite).serializable_hash }, status: :created
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
        render json: { message: "#{@favorite.favoritable_type} removed from favorites" }
      else
        render json: { message: 'Favorite not found' }, status: :not_found
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
