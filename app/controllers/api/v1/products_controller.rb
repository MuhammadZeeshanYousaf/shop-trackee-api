class Api::V1::ProductsController < ApplicationController
  before_action :set_shop, except: %i[ show update destroy ]
  before_action :set_product, only: %i[ show update destroy ]

  # GET /products
  def index
    if @shop.present?
      render json: @shop.products, each_serializer: ProductSerializer
    else
      render json: {
        message: "#{current_devise_api_user&.name} is Unauthorized",
        error: "#{current_devise_api_user&.role} is not authorized to access products"
      }, status: :unauthorized
    end
  end

  # GET /products/1
  def show
    if @product.present?
      render json: @product, serializer: ProductSerializer
    else
      render json: { message: 'Product not found', error: "Product with id: #{params[:id]} does not exist." }, status: :not_found
    end
  end

  # GET /products/new
  def new
    @product = @shop.products.new
    render json: {
      product: @product,
      categories: Category.find_by type: Product.to_s
    }
  end

  # POST /products
  def create
    @product = @shop.products.new product_params

    if @product.save
      render json: @product, serializer: ProductSerializer, status: :created, location: api_v1_shop_product_url(@product)
    else
      render json: {
        message: 'Product not created',
        error: @product.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: {
        message: "Product '#{@product.name}' updated successfully",
        product: ProductSerializer.new(@product).serializable_hash
      }
    else
      render json: {
        message: "Product '#{@product.try(:name)}' cannot be updated",
        error: @product&.errors&.full_messages&.to_sentence
      }, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end


  private
  # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find_by id: params[:shop_id], seller: current_v1_api_user.seller
    end

    def set_product
      @product = Product.find params[:id], params[:shop_id]
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.permit :name, :description, :price, :stock_quantity
    end
end
