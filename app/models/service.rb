class Service < ApplicationRecord
  include ShopItemsModifiable
  include NameSearchable

  belongs_to :shop
  belongs_to :category
  has_many_attached :images
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :order_requests, as: :orderable, dependent: :destroy

  enum :charge_by, { hour: 0, day: 1, work: 2 }
  validates :name, :rate, :charge_by, presence: true
  delegate :name, to: :category, prefix: true, allow_nil: true
end
