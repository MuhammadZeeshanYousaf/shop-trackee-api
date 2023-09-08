class Api::V1::ProductsController < ApplicationController
  before_action :set_shop, except: %i[ show update destroy ]
  before_action :set_product, only: %i[ show update destroy create_or_upload replace_image remove_image recognize ]

  # GET /products
  def index
    render json: @shop.products, each_serializer: ProductSerializer
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
      product: @product.serializable_hash(except: :category_id, include: :images),
      categories: Category.where(category_type: Product.to_s).map(&:name)
    }
  end

  # POST /products
  def create
    @product = @shop.products.new product_params
    @product.category = Category.find_by_name params[:category_name]

    if @product.save
      render json: @product, serializer: ProductSerializer, status: :created, location: api_v1_shop_product_url(@shop, @product)
    else
      render json: {
        message: 'Product not created',
        error: @product.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product&.update(product_params)
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
    if @product&.destroy
      render json: { message: "Product deleted successfully" }
    else
      render json: { message: "Product with id: #{params[:id]} does not exist." }, status: :not_found
    end
  end

  # PUT /products/(:id)/images
  def create_or_upload
    if @product.present?
      @product.images.attach(params[:images])
    else
      @product = @shop.products.new(images: params[:images])
    end
    @product.category ||= Category.where(category_type: Product.to_s).first

    if @product.save(validate: false)
      render json: {
        message: 'Product image uploaded successfully',
        product: ProductSerializer.new(@product).serializable_hash.slice(:id, :images)
      }, status: :created, location: api_v1_shop_product_path(@shop, @product)
    else
      render json: {
        message: 'Product image cannot be uploaded',
        error: @product.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end

  # PATCH /products/:id/images/:image_id/replace
  def replace_image
    if @product&.remove_image(params[:image_id])
      @product.images.attach(params[:image])
      if @product.save(validate: false)
        return render(json: {
          message: 'Image replaced successfully',
          image: {
            id: @product.images.last.id,
            path: rails_blob_path(@product.images.last)
          }
        })
      else
        return render(json: {
          message: 'Previous image removed but new image not updated',
          error: @product.errors.full_messages.to_sentence
        })
      end
    end

    # if image not exist / not replaced
    render json: {
      message: 'Image not found',
      error: @product&.errors&.full_messages&.to_sentence
    }, status: :not_found
  end

  # DELETE /products/:id/images/:image_id
  def remove_image
    if @product&.remove_image(params[:image_id])
      render json: { message: "Image deleted successfully" }
    else
      render json: { message: "Image not found with id: #{params[:image_id]} and product id: #{params[:id]}" }, status: :not_found
    end
  end

  # GET /products/:id/images/:image_id/recognize
  def recognize
    if @product.present?
      image_key = @product.get_image_key(params[:image_id])
      image_data = AwsService::ImageRecognition.call(image_key)
      if image_data.length > 0
        # GENERATE OBJECT HERE
        first_label = image_data.first
        @product.assign_attributes first_label.slice(:name, :description)
        @product.category = Category.find_all_like(first_label[:categories]).first

        if @product.save
          return render(json: ProductSerializer.new(@product).serializable_hash.merge(first_label.slice(:certainty)))
        end
      end
    end

    render json: {
      message: 'Image not found',
      error: @product&.errors&.full_messages&.to_sentence
    }, status: :not_found
  end


  private
  # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find params[:shop_id]
    end

    def set_product
      @product = Product.find_by id: params[:id], shop_id: params[:shop_id]
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.permit :name, :description, :price, :stock_quantity, images: []
    end
end
