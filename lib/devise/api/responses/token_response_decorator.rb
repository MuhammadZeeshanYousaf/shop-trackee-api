# app/lib/devise/api/responses/token_response_decorator.rb
require_relative 'user_param_sanitizer'
include Rails.application.routes.url_helpers
module Devise::Api::Responses::TokenResponseDecorator
  def body
    if resource_owner.persisted? && @action == :sign_up
      resource_owner.update(Devise::Api::Responses::UserParamSanitizer.sanitize{|sanitized| @request.params.slice(*sanitized)})
    end

    additional_params = if resource_owner.role_seller?
      resource_owner.seller.serializable_hash(only: [:intro, :rating])
    elsif resource_owner.role_customer?
      resource_owner.customer.serializable_hash(only: [:vocation, :age, :newsletter_subscribed])
    else {} end
    @avatar_url = resource_owner.avatar.variant(:thumb).url || resource_owner.avatar.url if resource_owner.avatar.attached?

    default_body.merge(resource_owner: { **resource_owner.attributes.with_indifferent_access.slice(*Devise::Api::Responses::UserParamSanitizer.present),
                                         avatar: @avatar_url, **additional_params })
  end

end
