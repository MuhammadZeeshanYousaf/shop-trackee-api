class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api

  belongs_to :role
  has_one :business, dependent: :destroy

  delegate :admin?, :seller?, :customer?, to: :role, prefix: true

  before_validation do
    self.role = Role.find_by_name 'customer'
  end

end
