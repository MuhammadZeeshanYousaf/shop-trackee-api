class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price, default: 1.0
      t.integer :stock_quantity, default: 1
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
