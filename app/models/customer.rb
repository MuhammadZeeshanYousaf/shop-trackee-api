class Customer < ApplicationRecord
  belongs_to :user
  has_many :favorites
  has_many :search_histories

  validates :age, numericality: { greater_than: 5, less_than: 100 }

  def record_history(query)
    if query.length > 2 then search_histories.create(name: query) end
  end

end
