class RemoveDefaultRoleFromUser < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :role, from: 'customer', to: nil
  end
end
