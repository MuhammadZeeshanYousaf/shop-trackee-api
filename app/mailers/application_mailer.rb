class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("mailgun@#{ENV['MAILGUN_DOMAIN']}", APP_NAME)
  layout "mailer"
end
