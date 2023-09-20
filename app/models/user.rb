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
  has_many :favorites, through: :customer

  after_save :build_role_entity, unless: :role_entity_exist?
  after_create :send_welcome_email

  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def role_entity_exist?
    if role_seller?
      seller.present?
    elsif role_customer?
      customer.present?
    end
  end

  private
    def build_role_entity
      role_entity = role.camelize.constantize.new user: self
      role_entity.save validate: false
    end

    def send_welcome_email
      UserMailer.with(user: self).welcome_email.deliver_later
    end

end
