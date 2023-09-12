class Service < ApplicationRecord
  include ShopItemsModifiable
  belongs_to :shop
  belongs_to :category
  has_many_attached :images
  has_many :favorites, as: :favoritable

  enum :charge_by, { hour: 0, day: 1, work: 2 }
  validates :name, :rate, :charge_by, presence: true
  delegate :name, to: :category, prefix: true, allow_nil: true
end
