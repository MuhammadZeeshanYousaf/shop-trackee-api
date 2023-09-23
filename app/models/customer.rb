class Customer < ApplicationRecord
  belongs_to :user
  has_many :favorites
  has_many :search_histories
  has_many :order_requests

  validates :age, numericality: { greater_than: 5, less_than: 100 }

  def record_history(query)
    if query.is_a?(Array) && query.length > 0
      query = query.join(' ')
      search_histories.create(name: query)
    elsif query.is_a?(String) && query.length > 2
      search_histories.create(name: query)
    end
  end

end
