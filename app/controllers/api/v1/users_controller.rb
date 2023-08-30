class Api::V1::UsersController < ApplicationController
  before_action :set_user

  def update
    if @user.update(user_params)
      role_based_obj = {}
      if @user.customer?
        @customer = Customer.find_or_initialize_by user: @user
        @customer.assign_attributes customer_params
        if @customer.save
          role_based_obj = { customer: @customer.serializable_hash }
        else
          role_based_obj = { error: @customer.errors.full_messages.to_sentence }
        end
      elsif @user.seller?
        @seller = Seller.find_or_initialize_by user: @user
        @seller.assign_attributes seller_params
        if @seller.save
          role_based_obj = { seller: @seller.serializable_hash }
        else
          role_based_obj = { error: @seller.errors.full_messages.to_sentence }
        end
      end

      render json: {
        message: "#{@user.name}'s information updated successfully",
        user: UserSerializer.new(@user).serializable_hash,
        **role_based_obj
      }
    else
      render json: {
        message: "#{@user.name}'s' information not updated",
        error: @user.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end


  private

  def user_params
    params.permit(:name, :gender, :country, :phone, :address, :avatar)
  end

  def customer_params
    params.permit(:vocation, :age, :newsletter_subscribed)
  end

  def seller_params
    params.permit(:intro, :rating)
  end

  def set_user
    @user = current_devise_api_user
  end

end
