# app/lib/devise/api/responses/token_response_decorator.rb
require_relative 'user_param_sanitizer'
module Devise::Api::Responses::TokenResponseDecorator
  def body
    if resource_owner.persisted? && @action == :sign_up
      resource_owner.update(Devise::Api::Responses::UserParamSanitizer.sanitize{|sanitized| @request.params.slice(*sanitized)})
    end

    default_body.merge(resource_owner: { **resource_owner.attributes.with_indifferent_access.slice(*Devise::Api::Responses::UserParamSanitizer.present),
                                         avatar: Rails.application.routes.url_helpers.rails_blob_path(resource_owner.avatar, only_path: true) })
  end

end
