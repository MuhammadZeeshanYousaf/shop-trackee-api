class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  enum :name, {
    admin: 'admin',
    customer: 'customer',
    member: 'member'
  }

  has_many :users

end
