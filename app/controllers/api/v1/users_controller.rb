class Api::V1::UsersController < ApplicationController
  before_action :set_user

  def update
    if @user.update(user_params)
      render json: {
        message: "#{@user.name}'s information updated successfully",
        user: UserSerializer.new(@user).serializable_hash
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

  def set_user
    @user = current_devise_api_user
  end

end
