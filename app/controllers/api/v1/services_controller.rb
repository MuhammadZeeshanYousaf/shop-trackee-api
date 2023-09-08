class Api::V1::ServicesController < ApplicationController
  include ShopItemsCommonActions
  before_action :set_shop, except: %i[ show update destroy ]
  before_action :set_service, only: %i[ show update destroy ]

  # GET /services
  def index
    render json: @shop.services, each_serializer: ServiceSerializer
  end

  # GET /services/1
  def show
    if @service.present?
      render json: @service, serializer: ServiceSerializer
    else
      render json: { message: 'Service not found', error: "Service with id: #{params[:id]} does not exist." }, status: :not_found
    end
  end

  # GET /services/new
  def new
    @service = @shop.services.new
    service_attrs = @service.serializable_hash(except: :category_id, include: :images)
    service_attrs[:charge_by] = Service.charge_bies.keys

    render json: {
      service: service_attrs,
      categories: Category.where(category_type: Service.to_s).map(&:name)
    }
  end

  # POST /services
  def create
    @service = @shop.services.new service_params
    @service.category = Category.find_by_name params[:category_name]

    if @service.save
      render json: @service, serializer: ServiceSerializer, status: :created, location: api_v1_shop_service_url(@shop, @service)
    else
      render json: {
        message: 'Service not created',
        error: @service.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /services/1
  def update
    if @service&.update(service_params)
      render json: {
        message: "Service '#{@service.name}' updated successfully",
        product: ServiceSerializer.new(@service).serializable_hash
      }
    else
      render json: {
        message: "Service '#{@service.try(:name)}' cannot be updated",
        error: @service&.errors&.full_messages&.to_sentence
      }, status: :unprocessable_entity
    end
  end

  # DELETE /services/1
  def destroy
    if @service&.destroy
      render json: { message: "Service '#{@service.name}' deleted successfully" }
    else
      render json: { message: "Service with id: #{params[:id]} does not exist." }, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find params[:shop_id]
    end

    def set_service
      @service = Service.find_by id: params[:id], shop_id: params[:shop_id]
    end

    # Only allow a list of trusted parameters through.
    def service_params
      params.permit :name, :description, :rate, :charge_by, images: []
    end
end
