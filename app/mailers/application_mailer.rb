class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(ENV['MAILGUN_DOMAIN'], APP_NAME)
  layout "mailer"
end
