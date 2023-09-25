class Api::V1::OrderRequestsController < ApplicationController
  before_action :set_role_objects
  before_action :set_orderable, only: :create
  before_action :set_customer_order_request, only: [ :destroy, :update ]
  before_action :set_seller_order_request, only: :update_status

  # GET /order_requests
  def index
    @object = @customer.present? ? @customer : @seller
    @ability.authorize! :read, @object
    render json: @object.order_requests, each_serializer: OrderRequestSerializer
  end

  # POST customer/order_requests
  def create
    @ability.authorize! :manage, @customer
    @order_request = @customer.order_requests.new(order_request_params)
    @order_request.assign_attributes orderable: @orderable, shop_id: @orderable.shop_id
    @ability.authorize! :create, @order_request

    if @order_request.save
      render json: {
        message: 'Order request created',
        order_request: OrderRequestSerializer.new(@order_request).serializable_hash(except: :customer)
      }, status: :created
    else
      render json: {
        message: 'Order request cannot be created',
        error: @order_request.errors.full_messages.to_sentence
      }
    end
  end

  # PUT/PATCH customer/order_requests/:id
  def update
    @ability.authorize! :update, @order_request

    if @order_request.pending? && @order_request.update(order_request_params)
      return render json: { message: 'Order request message updated successfully', order_request: OrderRequestSerializer.new(@order_request).serializable_hash }
    end

    render json: { message: 'Order request message cannot be updated', error: @order_request&.errors&.full_messages&.to_sentence }, status: :forbidden
  end

  # DELETE customer/order_requests/:id
  def destroy
    @ability.authorize! :destroy, @order_request

    if @order_request.pending? && @order_request.destroy
      return render json: { message: 'Order request cancelled successfully' }
    end

    render json: { message: 'Order request cannot be cancelled', error: @order_request&.errors&.full_messages&.to_sentence }, status: :unprocessable_entity
  end

  def update_status
    if params[:status].eql?('accept') && @order_request&.accepted!
      render json: { message: 'Order request accepted', order_request: OrderRequestSerializer.new(@order_request).serializable_hash }

    elsif params[:status].eql?('reject') && @order_request&.rejected!
      render json: { message: 'Order request rejected', order_request: OrderRequestSerializer.new(@order_request).serializable_hash }

    else
      render json: { message: 'Order request cannot be accepted / rejected', error: @order_request&.errors&.full_messages&.to_sentence }, status: :bad_request

    end
  end

  def remove
    if request.path.include?(Customer.to_s.underscore) && @ability.can?(:manage, @customer)
      @order_request = @customer.order_requests.find_by_id params[:id]
      @removed_by = Customer.to_s.underscore

    elsif request.path.include?(Seller.to_s.underscore) && @ability.can?(:manage, @seller)
      @order_request = @seller.order_requests.find_by_id params[:id]
      @removed_by = Seller.to_s.underscore

    else
      @ability.authorize! :destroy, nil
    end


    if @order_request.present? && @order_request.removed_by.blank?
      return render json: { message: 'Order Request removed successfully' } if @order_request.update_attribute :removed_by, @removed_by
    elsif User.roles.values.include?(@order_request.try(:removed_by))
      return render json: { message: 'Order Request removed successfully' } if @order_request.destroy
    end

    render json: { message: 'Order Request not found' }, status: :not_found
  end


  private
    def set_role_objects
      @customer = current_devise_api_user.customer
      @seller   = current_devise_api_user.seller
    end

    def set_orderable
      if params[:orderable_type].present?
        @orderable = params[:orderable_type].camelize.constantize.find_by_id(params[:orderable_id])
      end
    end

    def set_customer_order_request
      @ability.authorize! :manage, @customer
      @order_request = @customer.order_requests.find_by_id params[:id]
    end

    def set_seller_order_request
      @ability.authorize! :manage, @seller
      @order_request = @seller.order_requests.find_by_id params[:id]
    end

    def order_request_params
      params.permit :message
    end


end
