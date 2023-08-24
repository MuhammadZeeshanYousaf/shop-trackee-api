# app/lib/devise/api/responses/token_response_decorator.rb
require_relative 'user_param_sanitizer'
module Devise::Api::Responses::TokenResponseDecorator
  def body
    if resource_owner.persisted? && @action == :sign_up
      role_id = Role.find_by_name(@request.params[:role]).try(:id)
      @role_hash = { role_id: role_id } if role_id.present?
      resource_owner.update(Devise::Api::Responses::UserParamSanitizer.sanitize{|sanitized| @request.params.slice(*sanitized)}.merge(@role_hash || {}))
    end
    default_body.merge(resource_owner: { **resource_owner.attributes.with_indifferent_access.slice(*Devise::Api::Responses::UserParamSanitizer.present), role: resource_owner.role.name })
  end

end
