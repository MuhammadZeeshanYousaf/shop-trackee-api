class AddPublishedToProductService < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :published, :boolean, default: false
    add_column :services, :published, :boolean, default: false
  end
end
