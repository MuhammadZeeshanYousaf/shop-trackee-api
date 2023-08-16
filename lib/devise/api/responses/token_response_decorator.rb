# app/lib/devise/api/responses/token_response_decorator.rb
module Devise::Api::Responses::TokenResponseDecorator
  def body
    default_body.merge({ role: resource_owner.role.name })
  end
end
