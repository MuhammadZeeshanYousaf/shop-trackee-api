class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.references :parent_category, foreign_key: { to_table: :categories }

      t.timestamps
    end

    add_reference :businesses, :category, foreign_key: true
  end
end
