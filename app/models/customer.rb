class Customer < ApplicationRecord
  belongs_to :user
  has_many :favorites
  has_many :search_histories
  has_many :order_requests, -> { where("removed_by != 'customer' OR removed_by IS NULL") }

  validates :age, numericality: { greater_than: 5, less_than: 100 }

  def record_history(query)
    if query.is_a?(Array) && query.length > 0
      search_histories.create(queries: query)
    elsif query.is_a?(String) && query.length > 1
      search_histories.create(name: query)
    end
  end

end
