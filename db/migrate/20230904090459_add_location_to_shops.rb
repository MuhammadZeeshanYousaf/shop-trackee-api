class AddLocationToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :latitude, :decimal, precision: 10, scale: 8
    add_column :shops, :longitude, :decimal, precision: 11, scale: 8
  end
end
