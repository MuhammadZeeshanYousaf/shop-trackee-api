class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  # service: :amazon
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api

  enum :role, {
    seller: 'seller',
    customer: 'customer'
  }, prefix: true
  validates :role, presence: true, inclusion: { in: roles.values }

  has_one :customer
  has_one :seller

  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

end
