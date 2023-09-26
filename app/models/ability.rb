# See the wiki for details:
# https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?
    can :update, User, id: user.id

    if user.customer?
      can :manage, Customer
      can :read, Shop
      can :manage, OrderRequest, role: user.customer

    elsif user.seller?
      can :manage, Seller
      can :manage, Shop, role: user.seller
      can :read, OrderRequest

    end

  end
end
