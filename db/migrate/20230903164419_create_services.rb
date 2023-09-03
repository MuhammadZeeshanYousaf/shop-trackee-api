class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
      t.decimal :rate, default: 1.0
      t.integer :charge_by, default: 0, comment: 'A rails enum, it could be charge by hour, day, work respectively.'
      t.references :category, null: false, foreign_key: true
      t.belongs_to :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
