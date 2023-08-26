class CreateSellers < ActiveRecord::Migration[7.0]
  def change
    create_table :sellers do |t|
      t.text :intro, comment: 'A short introduction for customers.'
      t.integer :rating, default: 0
      t.string :website_url, comment: 'Business website url.'
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
