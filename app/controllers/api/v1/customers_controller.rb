class Api::V1::CustomersController < ApplicationController
  before_action :set_customer

  def search_all
    shop_ids = ShopsNearMeService.call(*search_params.values)

    shops = Shop.where(id: shop_ids)
    products = Product.where(shop_id: shops.ids)
    services = Service.where(shop_id: shops.ids)

    generate_hashes(shops, products, services)

    render json: {
      shops: @shop_hashes,
      products: @product_hashes,
      services: @service_hashes
    }
  end

  def search
    if params[:q].is_a? ActionDispatch::Http::UploadedFile
      @history = @customer.search_histories.create(image: params[:q])
      image_data = AwsService::ImageRecognition.call(@history.image.key)
      @query = image_data.map { |label_data| label_data[:name] }

    else @query = params[:q] end

    if @query.is_a?(String) || @query.is_a?(Array)
      shop_ids = ShopsNearMeService.call(*search_params.values)
      @history.present? ? @history.record_it(@query) : @customer.record_history(@query)

      shops = Shop.where(id: shop_ids)
      products = Product.where(shop_id: shops.ids).search_like(@query)
      services = Service.where(shop_id: shops.ids).search_like(@query)

      generate_hashes(shops, products, services)

      render json: {
        shops: @shop_hashes,
        products: @product_hashes,
        services: @service_hashes
      }
    else
      render json: { message: 'Bad Request' }, status: :bad_request
    end
  end


  private

    def set_customer
      @customer = current_devise_api_user.customer
      @ability.authorize! :manage, @customer
    end

    def search_params
      # order of params strictly matters here
      params.permit(:distance, :latitude, :longitude)
    end

    def generate_hashes(shops, products, services)
      @shop_hashes = shops.reduce([]) do |shop_hashes, shop|
        shop_hashes << ShopSerializer.new(shop).serializable_hash
      end

      @product_hashes = products.reduce([]) do |product_hashes, product|
        product_hashes << ProductSerializer.new(product).serializable_hash
      end

      @service_hashes = services.reduce([]) do |service_hashes, service|
        service_hashes << ServiceSerializer.new(service).serializable_hash
      end
    end

end
