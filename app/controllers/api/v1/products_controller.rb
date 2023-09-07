class Api::V1::ProductsController < ApplicationController
  before_action :set_shop, except: %i[ show update destroy ]
  before_action :set_product, only: %i[ show update destroy create_or_upload replace_image recognize ]

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
      render json: { message: "Product '#{@product.name}' deleted successfully" }
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
        images: ProductSerializer.new(@product).serializable_hash(only: :images)
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
      if @product.images.attach(params[:image])
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

  # GET /products/:id/images/:image_id/recognize
  def recognize
    image_key = @product&.get_image_key(params[:image_id])
    if image_key.present?
      client = Aws::Rekognition::Client.new
      attrs = {
        image: {
          s3_object: {
            bucket: ENV['AWS_DEFAULT_BUCKET'],
            name: image_key
          },
        },
        max_labels: 5
      }
      response = client.detect_labels attrs
      response.labels.each do |label|
        puts "Label:      #{label.name}"
        puts "Confidence: #{label.confidence}"
        puts "Instances:"
        label['instances'].each do |instance|
          box = instance['bounding_box']
          puts "  Bounding box:"
          puts "    Top:        #{box.top}"
          puts "    Left:       #{box.left}"
          puts "    Width:      #{box.width}"
          puts "    Height:     #{box.height}"
          puts "  Confidence: #{instance.confidence}"
        end
        puts "Parents:"
        label.parents.each do |parent|
          puts "  #{parent.name}"
        end
        puts "------------"
        puts ""
      end

      # RESPONSE CODE PENDING...
    else
      render json: {
        message: 'Image not found',
        error: @product&.errors&.full_messages&.to_sentence
      }, status: :not_found
    end
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
