class Api::V1::SellersController < ApplicationController
  before_action :set_seller

  def stats
    products_count = @seller.products.count
    services_count = @seller.services.count
    customers_count = @seller.satisfied_customers_count
    total_revenue = @seller.total_revenue

    render json: {
      customers: customers_count,
      products: products_count,
      services: services_count,
      revenue: total_revenue
    }
  end


  private
    def set_seller
      @seller = current_devise_api_user.seller
      @ability.authorize! :manage, @seller
    end

end
