class ChangePriceRateType < ActiveRecord::Migration[7.0]
  def up
    change_column :products, :price, :float, default: 1
    change_column :services, :rate, :float, default: 1
  end

  def down
    change_column :products, :price, :decimal, default: '1.0'
    change_column :services, :rate, :decimal, default: '1.0'
  end
end
