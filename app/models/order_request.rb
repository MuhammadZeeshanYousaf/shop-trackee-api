class OrderRequest < ApplicationRecord
  belongs_to :customer
  belongs_to :shop
  belongs_to :orderable, polymorphic: true
  enum :status, { pending: 0, accepted: 1, rejected: 2 }
  paginates_per 8

  default_scope { order(created_at: :desc) }
  # Scopes for removed_by attribute
  scope :removed_by_customer, -> { where(removed_by: 'customer') }
  scope :removed_by_seller, -> { where(removed_by: 'seller') }

  delegate :price, to: :orderable, prefix: true

end
