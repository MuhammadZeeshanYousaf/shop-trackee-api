class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.bigint :favoritable_id, comment: "Product or Service Id"
      t.string :favoritable_type, comment: "Product or Service"

      t.timestamps
    end

    add_index :favorites, [:favoritable_id, :favoritable_type]
  end
end
