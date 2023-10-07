class ChangeUserRelation < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :role, :string
    add_reference :users, :role, polymorphic: true

    customer_user_ids = Customer.pluck(:id, :user_id)
    seller_user_ids   = Seller.pluck(:id, :user_id)

    User.find_each do |user|
      if customer_user_ids.map(&:second).include? user.id
        customer_user_ids.each do |customer_id, user_id|
          if user_id == user.id
            user.role_id = customer_id
            user.role_type = Customer.to_s
            user.save validate: false
          end
        end
      elsif seller_user_ids.map(&:second).include? user.id
        seller_user_ids.each do |seller_id, user_id|
          if user_id == user.id
            user.role_id = seller_id
            user.role_type = Seller.to_s
            user.save validate: false
          end
        end
      end
    end

    remove_reference :customers, :user
    remove_reference :sellers, :user
  end


  def down
    add_column :users, :role, :string
    add_reference :sellers, :user
    add_reference :customers, :user

    User.find_each do |user|
      if user.role_type.present?
        user.update_column :role, user.role_type.underscore

        role_item = user.role_type.camelize.constantize.find(user.role_id)
        role_item.update_attribute :user_id, user.id
      end
    end

    remove_reference :users, :role, polymorphic: true
  end

end
