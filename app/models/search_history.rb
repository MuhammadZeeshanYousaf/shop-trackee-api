class SearchHistory < ApplicationRecord
  include NameSearchable
  belongs_to :customer
  has_one_attached :image

  validates :name, uniqueness: true
end
