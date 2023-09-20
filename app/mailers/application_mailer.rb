class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(ENV['MAILJET_DEFAULT_FROM'], APP_NAME)
  layout "mailer"
end
