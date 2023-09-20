class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    mail(to: email_address_with_name(@user.email, @user.name), subject: "Welcome to #{APP_NAME}!")
  end

end
