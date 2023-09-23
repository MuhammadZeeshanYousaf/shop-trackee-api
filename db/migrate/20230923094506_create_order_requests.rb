class CreateOrderRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :order_requests do |t|
      t.integer :status, default: 0
      t.text :message
      t.belongs_to :customer, null: false, foreign_key: true
      t.belongs_to :shop
      t.references :orderable, polymorphic: true
      t.string :removed_by

      t.timestamps
    end
  end
end
