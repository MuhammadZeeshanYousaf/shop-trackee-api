class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  # service: :amazon
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api

  belongs_to :role, polymorphic: true, optional: true
  alias_attribute :role_name, :role_type
  has_many :favorites, through: :role

  after_save :build_role, if: :role_blank?
  after_create :send_welcome_email

  delegate :can?, :cannot?, to: :ability


  def ability
    @ability ||= Ability.new(self)
  end

  def customer
    role if role.is_a?(Customer)
  end

  def customer?
    role_type.camelize == Customer.to_s
  end

  def seller
    role if role.is_a?(Seller)
  end

  def seller?
    role_type.camelize == Seller.to_s
  end

  def role_blank?
    role_id.blank?
  end

  def build_role
    if role_type.present?
      role_object = role_type.camelize.constantize.new
      role_object.save validate: false
      self.update_attribute :role, role_object
      role_object
    end
  end

  private
    def send_welcome_email
      UserMailer.with(user: self).welcome_email.deliver_later
    end

end
