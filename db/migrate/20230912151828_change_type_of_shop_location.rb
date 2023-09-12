class ChangeTypeOfShopLocation < ActiveRecord::Migration[7.0]
  def up
    change_column :shops, :latitude, :float
    change_column :shops, :longitude, :float
  end

  def down
    change_column :shops, :latitude, :decimal, precision: 10, scale: 8
    change_column :shops, :longitude, :decimal, precision: 11, scale: 8
  end
end
