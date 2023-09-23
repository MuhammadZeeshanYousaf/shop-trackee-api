class Api::V1::OrderRequestsController < ApplicationController
  before_action :set_role_objects, only: [ :create, :index, :destroy ]
  before_action :set_orderable, only: :create
  before_action :set_order_request, only: [ :destroy, :update ]

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

  def update

  end

  # DELETE customer/order_requests
  def destroy
    @ability.authorize! :destroy, @order_request

    if @order_request.pending? && @order_request.destroy
      return render json: { message: 'Order request cancelled successfully' }
    end

    render json: { message: 'Order request cannot be cancelled', error: @order_request&.errors&.full_messages&.to_sentence }
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

    def set_order_request
      @ability.authorize! :manage, @customer
      @order_request = @customer.order_requests.find_by_id params[:id]
    end

    def order_request_params
      params.permit :message
    end


end
