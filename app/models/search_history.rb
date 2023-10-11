class SearchHistory < ApplicationRecord
  include NameSearchable

  default_scope { where("name <> NULL OR name <> ''").order(created_at: :desc) }
  belongs_to :customer
  has_one_attached :image

  def record_it(query)
    if query.is_a?(Array) && query.length > 0
      update_attribute(:name, query.first)
    elsif query.is_a?(String) && query.length > 2
      update_attribute(:name, query)
    end
  end

end
