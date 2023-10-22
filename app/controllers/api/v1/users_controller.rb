class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_devise_api_token!, :set_ability, only: [ :send_password_reset_link, :secure_account, :reset_password ]
  before_action :set_user

  def update
    if @user.update(user_params)
      role_based_obj = {}
      if @user.role_customer?
        @customer = Customer.find_or_initialize_by user: @user
        @customer.assign_attributes customer_params
        if @customer.save
          role_based_obj = { customer: @customer.serializable_hash }
        else
          role_based_obj = { error: @customer.errors.full_messages.to_sentence }
        end
      elsif @user.role_seller?
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

  # POST /user/send_password_reset_link
  def send_password_reset_link
    @user = User.find_by_email params[:email]

    if @user.present?
      @user.send_password_reset_link
      render json: { message: 'Password reset link has been sent to your email' }
    else
      render json: { message: 'User with this email does not exist!' }, status: :not_found
    end
  end

  # GET | POST /user/reset_password/:token
  def reset_password
    @user = User.find_by_password_reset_token params[:token] if params[:token].present?
    return render json: { ok: false } if @user.blank?

    if request.get?
      render json: { ok: true, email: @user.email }

    elsif request.post?
      if @user.update(password: params[:new_password])
        @user.regenerate_password_reset_token

        render json: { ok: true, message: 'Password has been updated successfully' }
      else
        render json: { ok: false, message: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  end

  # POST /user/update_password
  def update_password
    if @user.valid_password? params[:prev_password]
      if @user.update password: params[:new_password]
        render json: { ok: true, message: 'Password updated successfully' }
      else
        render json: { ok: false, message: @user.errors.full_messages.to_sentence }
      end

    else
      render json: { ok: false, message: 'Previous password is incorrect' }
    end
  end

  # GET /user/secure_account/:token
  def secure_account
    @user = User.find_by_password_reset_token params[:token] if params[:token].present?
    return render json: { ok: false } if @user.blank?

    @user.regenerate_password_reset_token
    render json: { ok: true, message: 'Thank you for the confirmation' }
  end


  private

  def user_params
    params.permit(:name, :gender, :country, :phone, :address, :avatar)
  end

  def customer_params
    params.permit(:vocation, :age, :newsletter_subscribed)
  end

  def seller_params
    params.permit(:intro)
  end

  def set_user
    @user = current_devise_api_user
  end

end
