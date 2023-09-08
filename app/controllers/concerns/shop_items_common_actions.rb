module ShopItemsCommonActions
  extend ActiveSupport::Concern

  included do
    before_action :set_item_object, only: %i[ create_or_upload ]

    private
      def set_item_object
        @object = controller_name.singularize.camelize.constantize.find_by id: params[:id], shop_id: params[:shop_id]
        @object = controller_name.singularize.camelize.constantize.new if @object.blank?
      end
  end


  # PUT /object/(:id)/images
  def create_or_upload
    if @object.persisted?
      @object.images.attach(params[:images])
    else
      @object = @shop.send(@object.class.to_s.underscore.pluralize).new(images: params[:images])
    end
    @object.category ||= Category.where(category_type: @object.class.to_s).first

    if @object.save(validate: false)
      render json: {
        message: @object.class.to_s + ' image uploaded successfully',
        "#{@object.class.to_s.underscore.pluralize}" => @object.class.to_s.concat('Serializer').constantize.new(@object).serializable_hash.slice(:id, :images)
      }, status: :created
    else
      render json: {
        message: @object.class.to_s + ' image cannot be uploaded',
        error: @object.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end

end
