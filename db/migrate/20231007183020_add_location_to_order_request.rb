class AddLocationToOrderRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :order_requests, :latitude, :float
    add_column :order_requests, :longitude, :float
  end
end
