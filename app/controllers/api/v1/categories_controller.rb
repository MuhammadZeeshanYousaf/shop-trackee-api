class Api::V1::CategoriesController < ApplicationController

  def index
    category_type = params[:type].to_s.camelize

    if category_type.present? && [Product.to_s, Service.to_s].include?(category_type)
      @categories = Category.where(category_type: category_type).pluck(:name)
    else
      @categories = Category.pluck(:name)
    end

    render json: { categories: @categories, type: category_type }
  end

end
