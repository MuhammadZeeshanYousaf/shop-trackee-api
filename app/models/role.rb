class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  enum :name, {
    admin: 'admin',
    seller: 'seller',
    customer: 'customer',
  }

  has_many :users

end
