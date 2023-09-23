class OrderRequest < ApplicationRecord
  belongs_to :customer
  belongs_to :shop
  belongs_to :orderable, polymorphic: true

  enum :status, { pending: 0, accepted: 1, rejected: 2 }

end
