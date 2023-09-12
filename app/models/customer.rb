class Customer < ApplicationRecord
  belongs_to :user
  has_many :favorites

  validates :age, numericality: { greater_than: 5, less_than: 100 }
end
