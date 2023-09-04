class Api::V1::ShopsController < ApplicationController
  before_action :set_seller
  before_action :set_shop, only: %i[ show update destroy ]

  # GET /shops
  def index
    if @seller.present?
      render json: @seller.shops, each_serializer: ShopSerializer
    else
      render json: {
        message: "#{current_devise_api_user&.name} is Unauthorized",
        error: "#{current_devise_api_user&.role} is not authorized to access shops"
      }, status: :unauthorized
    end
  end

  # GET /shops/1
  def show
    if @shop.present?
      render json: @shop, serializer: ShopSerializer
    else
      render json: { message: 'Shop not found', error: "Shop with id: #{params[:id]} does not exist." }, status: :not_found
    end
  end

  # POST /shops
  def create
    @shop = @seller.shops.new shop_params

    if @shop.save
      render json: @shop, serializer: ShopSerializer, status: :created, location: api_v1_shop_url(@shop)
    else
      render json: {
        message: 'Shop not created',
        error: @shop.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shops/1
  def update
    if @shop.update(shop_params)
      render json: {
        message: "Shop '#{@shop.name}' updated successfully",
        shop: ShopSerializer.new(@shop).serializable_hash
      }
    else
      render json: {
        message: "Shop '#{@shop.try(:name)}' cannot be updated",
        error: @shop&.errors&.full_messages&.to_sentence
      }, status: :unprocessable_entity
    end
  end

  # DELETE /shops/1
  def destroy
    if @shop&.destroy
      render json: { message: "Shop '#{@shop.name}' deleted successfully" }
    else
      render json: {
        message: "Shop cannot be deleted",
        error: @shop&.errors&.full_messages&.to_sentence
      }, status: :not_found
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seller
      @seller = current_devise_api_user.seller
    end

    def set_shop
      @shop = Shop.find_by id: params[:id], seller: @seller
    end

    # Only allow a list of trusted parameters through.
    def shop_params
      params.permit :name, :description, :address, :contact, :latitude, :longitude,
                    :opening_time, :closing_time, :shop_website_url, closing_days: [], social_links: []
    end

end
