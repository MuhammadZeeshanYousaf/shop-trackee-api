class Service < ApplicationRecord
  include ShopItemsModelConcern, NameSearchable
  paginates_per 6
  max_pages 100

  belongs_to :shop
  belongs_to :category
  has_many_attached :images do |attachable|
    attachable.variant :short, resize_to_limit: [250, 250]
  end
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :order_requests, as: :orderable, dependent: :destroy

  enum :charge_by, { hour: 0, day: 1, work: 2 }
  validates :name, :rate, :charge_by, presence: true
  delegate :name, to: :category, prefix: true, allow_nil: true
  alias_attribute :price, :rate

end
