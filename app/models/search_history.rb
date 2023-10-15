class SearchHistory < ApplicationRecord
  include NameSearchable

  default_scope { where("name <> NULL OR name <> ''").order(updated_at: :desc) }
  belongs_to :customer
  has_one_attached :image

  def record_it(query)
    touch_later
    if query.is_a?(Array) && query.length > 0
      update_attribute(:queries, query)
    elsif query.is_a?(String) && query.length > 1
      update_attribute(:name, query)
    end
  end

  # @return [Array|String]
  def latest_search
    if queries? && name?
      queries << name
    elsif queries? then queries
    elsif name? then name end
  end

end
