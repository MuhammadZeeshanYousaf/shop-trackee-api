class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, table_comment: 'Every product or service of a shop will belong to a category.' do |t|
      t.string :name
      t.string :category_type
      t.references :parent, foreign_key: { to_table: :categories }, comment: 'Category can be sub-category and it will have a parent.'

      t.timestamps
    end
  end
end
