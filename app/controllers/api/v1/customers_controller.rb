class Api::V1::CustomersController < ApplicationController
  before_action :set_customer


  def home
    shop_ids = ShopsNearMeService.call(*search_params.values)

    # shops = Shop.where(id: shop_ids)
    products = Product.where(shop_id: shop_ids).page
    services = Service.where(shop_id: shop_ids).page

    generate_hashes([], products, services)
    @product_categories = Category.service_type.pluck :name
    @service_categories = Category.product_type.pluck :name


    render json: {
      product: {
        categories: @product_categories,
        data: @product_hashes
      },
      service: {
        categories: @service_categories,
        data: @service_hashes
      },
      # shops: @shop_hashes
    }

  end

  def search_all
    type = params[:type]
    product_page = params[:product_page]
    service_page = params[:service_page]
    shop_page    = params[:shop_page]
    shop_ids = ShopsNearMeService.call(*search_params.values)

    if type.present? && type.camelize.eql?(Product.to_s)
      @products = Product.where(shop_id: shop_ids).page(product_page)
      @shops = Shop.where(id: @products.pluck(:shop_id))
      @services = []

    elsif type.present? && type.camelize.eql?(Service.to_s)
      @services = Service.where(shop_id: shop_ids).page(service_page)
      @shops = Shop.where(id: @services.pluck(:shop_id))
      @products = []

    else
      @shops = Shop.where(id: shop_ids).page(shop_page)
      @products = Product.where(shop_id: @shops.ids).page(product_page)
      @services = Service.where(shop_id: @shops.ids).page(service_page)

    end

    generate_hashes(@shops, @products, @services)

    render json: {
      product: {
        current_page: @products.try(:current_page),
        total_pages: @products.try(:total_pages),
        data: @product_hashes,
      },
      service: {
        current_page: @services.try(:current_page),
        total_pages: @services.try(:total_pages),
        data: @service_hashes
      },
      shop: {
        current_page: @shops.try(:current_page),
        total_pages: @shops.try(:total_pages),
        data: @shop_hashes
      }
    }
  end

  def search
    if request.post? && params[:q].is_a?(ActionDispatch::Http::UploadedFile)
      @history = @customer.search_histories.create(image: params[:q])
      image_data = AwsService::ImageRecognition.call(@history.image.key)
      @query = image_data.map { |label_data| label_data[:name] }

    elsif request.post? && params[:q].match(/\Adata:image\/\w+;base64,/).present?
      @history = @customer.search_histories.new
      @history.image.attach Base64ImgToHash.call(params[:q])
      @history.save
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
      render json: { message: 'Invalid format for search query', error: 'Bad Request' }, status: :bad_request
    end
  end

  def search_by_category
    type = params[:type]
    category_name = params[:q]
    product_page  = params[:product_page]
    service_page  = params[:service_page]
    shop_page     = params[:shop_page]

    @category_ids = Category.where(name: category_name).ids
    @category_ids = Category.search_like(category_name).ids if @category_ids.blank?

    if @category_ids.present?
      shop_ids = ShopsNearMeService.call(*search_params.values)

      if type.present? && type.camelize.eql?(Product.to_s)
        @products = Product.where(shop_id: shop_ids, category_id: @category_ids).page(product_page)
        @shops = Shop.where(id: @products.pluck(:shop_id))
        @services = []

      elsif type.present? && type.camelize.eql?(Service.to_s)
        @services = Service.where(shop_id: shop_ids, category_id: @category_ids).page(service_page)
        @shops = Shop.where(id: @services.pluck(:shop_id))
        @products = []

      else
        @products = Product.where(shop_id: shop_ids, category_id: @category_ids).page(product_page)
        @services = Service.where(shop_id: shop_ids, category_id: @category_ids).page(service_page)
        shop_ids = (@products.pluck(:shop_id) + @services.pluck(:shop_id)).uniq
        @shops = Shop.where(id: shop_ids).page(shop_page)

      end

      generate_hashes(@shops, @products, @services)
    else
      return render json: { error: 'Must provide valid category name!' }, status: :bad_request
    end

    render json: {
      product: {
        current_page: @products.try(:current_page),
        total_pages: @products.try(:total_pages),
        data: @product_hashes,
      },
      service: {
        current_page: @services.try(:current_page),
        total_pages: @services.try(:total_pages),
        data: @service_hashes
      },
      shop: {
        current_page: @shops.try(:current_page),
        total_pages: @shops.try(:total_pages),
        data: @shop_hashes
      }
    }
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
