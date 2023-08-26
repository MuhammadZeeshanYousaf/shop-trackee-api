class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api

  enum :role, {
    seller: 'seller',
    customer: 'customer'
  }
  validates :name, :role, presence: true

  has_one :customer

end
