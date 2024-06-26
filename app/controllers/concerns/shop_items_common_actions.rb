module ShopItemsCommonActions
  extend ActiveSupport::Concern

  included do
    before_action :set_item_object, only: %i[ create_or_upload replace_image remove_image recognize ]

    private
      def set_item_object
        @object = controller_name.singularize.camelize.constantize.find_by id: params[:id], shop_id: params[:shop_id]
        @object = controller_name.singularize.camelize.constantize.new if @object.blank?
      end
  end


  # PUT /objects/(:id)/images
  def create_or_upload
    return head :bad_request if params[:images].empty?
    images = params[:images]

    unless @object.persisted?
      @object = @shop.send(@object.class.to_s.underscore.pluralize).new
    end

    images.each do |img|
      if img.is_a? String
        # The img is Base64 and coming from the camera
        @object.images.attach Base64ImgToHash.call(img)
      else
        @object.images.attach(img)
      end
    end
    @object.category ||= Category.where(category_type: @object.class.to_s).first

    if @object.save(validate: false)
      render json: {
        message: @object.class.to_s + ' image uploaded successfully',
        "#{@object.class.to_s.underscore.pluralize}" => ActiveModelSerializers::SerializableResource.new(@object).serializable_hash.slice(:id, :images)
      }, status: :created
    else
      render json: {
        message: @object.class.to_s + ' image cannot be uploaded',
        error: @object.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end

  # PATCH /objects/:id/images/:image_id/replace
  def replace_image
    if @object.persisted? && @object.remove_image(params[:image_id])
      @object.images.attach(params[:image])
      if @object.save(validate: false)
        return render(json: {
          message: 'Image replaced successfully',
          image: {
            id: @object.images.last.id,
            path: rails_blob_path(@object.images.last)
          }
        })
      else
        return render(json: {
          message: 'Previous image removed but new image not updated',
          error: @object.errors.full_messages.to_sentence
        })
      end
    end

    # if image not exist / not replaced
    render json: {
      message: 'Image not found',
      error: @object&.errors&.full_messages&.to_sentence
    }, status: :not_found
  end

  # DELETE /objects/:id/images/:image_id
  def remove_image
    if @object&.remove_image(params[:image_id])
      render json: { message: "Image deleted successfully" }
    else
      render json: { message: "Image not found with id: #{params[:image_id]} and #{@object.class.to_s.underscore} id: #{params[:id]}" }, status: :not_found
    end
  end

  # GET /objects/:id/images/:image_id/recognize
  def recognize
    if @object.persisted?
      image_key = @object.get_image_key(params[:image_id])
      image_data = AwsService::ImageRecognition.call(image_key)

      if image_data.length > 0
        @objects = []
        # Generate objects
        image_data.each do |label_data|
          if label_data[:categories].blank?
            category = Category.search_like(label_data[:categories]).where(category_type: @object.class.to_s).last
          else
            category = Category.find_by(name: label_data[:categories], category_type: @object.class.to_s)
            category = Category.create(name: label_data[:categories].first, category_type: @object.class.to_s) if category.blank?
          end

          object = @object.class.new label_data.slice(:name, :description).merge(shop_id: @object.shop_id, category_id: category.id)

          @objects << object
        end

        return render(json: @objects, each_serializer: @object.class.to_s.concat('Serializer').constantize)
      end
    end

    render json: {
      message: 'Image not found',
      error: @object&.errors&.full_messages&.to_sentence
    }, status: :not_found
  end


end
