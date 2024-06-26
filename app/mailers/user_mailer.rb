class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]

    mail(to: email_address_with_name(@user.email, @user.name), subject: "Welcome to #{APP_NAME}!")
  end

  def password_reset_email
    @user = params[:user]
    reset_token = if @user.password_reset_token.present?
                    @user.password_reset_token
                  else
                    @user.regenerate_password_reset_token && @user.password_reset_token
                  end

    @secure_account_url = secure_account_api_v1_user_url(reset_token)
    @reset_password_url = "#{APP_HOST_URL}/reset-password/?token=#{reset_token}"

    mail(to: email_address_with_name(@user.email, @user.name), subject: "Request to reset password for #{@user.name}")
  end

end
