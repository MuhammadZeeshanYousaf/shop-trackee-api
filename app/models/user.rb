class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api

  enum :role, {
    seller: 'seller',
    customer: 'customer'
  }
  validates :role, presence: true, inclusion: { in: roles.values }

  has_one :customer
  has_one :seller

end
