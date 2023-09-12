class Api::V1::CustomersController < ApplicationController
  before_action :set_customer

  def search_all
    if @customer.present?
      provided_distance = params[:distance].to_i
      customer_latitude = params[:latitude].to_f
      customer_longitude = params[:longitude].to_f
      locations = Shop.where.not(latitude: nil, longitude: nil).pluck(:id, :latitude, :longitude)
      search_ids = []
      locations.each do |id, latitude, longitude|
        distance = Haversine.distance(latitude, longitude, customer_latitude, customer_longitude)
        if provided_distance >= distance.to_km
          search_ids << id
        end
      end

      shops = Shop.where(id: search_ids)
      products = Product.where(shop_id: shops.ids)
      services = Service.where(shop_id: shops.ids)

      shops = shops.reduce([]) do |shop_hashes, shop|
        shop_hashes << ShopSerializer.new(shop).serializable_hash
      end

      products = products.reduce([]) do |product_hashes, product|
        product_hashes << ProductSerializer.new(product).serializable_hash
      end

      services = services.reduce([]) do |service_hashes, service|
        service_hashes << ServiceSerializer.new(service).serializable_hash
      end


      render json: {
        shops: shops,
        products: products,
        services: services
      }
    else
      render json: {
        message: 'No record found'
      }, status: :not_found
    end

  end

  private

    def set_customer
      @customer = current_devise_api_user.customer
    end

end
