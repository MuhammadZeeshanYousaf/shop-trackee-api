class Api::V1::SearchHistoriesController < ApplicationController
  before_action :set_customer

  def history
    query = params[:q]
    search_history = SearchHistory.select(:name).distinct.where(customer: @customer).search_like(query).pluck(:name)
    render json: search_history
  end


  private

    def set_customer
      @customer = current_devise_api_user.customer
      @ability.authorize! :manage, @customer
    end
end
