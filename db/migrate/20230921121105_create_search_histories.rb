class CreateSearchHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :search_histories do |t|
      t.string :name, comment: 'Customer Search History text'
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
