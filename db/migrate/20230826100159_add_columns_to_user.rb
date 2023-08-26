class AddColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :country, :string, default: 'Pakistan'
    add_column :users, :phone, :string
    add_column :users, :address, :text
    add_column :users, :avatar, :string
    add_column :users, :role, :string, default: 'customer'
  end
end
