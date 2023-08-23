class Api::V1::BusinessesController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  before_action :set_business, only: %i(show update destroy)


  def index
  end

  def show
  end

  def create
    @user = current_devise_api_token.resource_owner
    @business = Business.new(business_params)
    @business.user = @user
    if @business.save
      render json: { message: 'Business successfully created.', data: @business }, status: :created
    else
      render json: { message: 'Business not created.', error: @business.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
  end


  private

  def set_business
    @user = current_devise_api_token.resource_owner
    @business = @user.business
  end

  def business_params
    params.require(:business).permit(:name, :description, :catagory_id)
  end

end
