class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.text :description
      t.string :address, comment: 'Custom address of shop.'
      t.string :contact, comment: 'Business contact number.'
      t.time :opening_time, comment: 'Format could be 16:57:19 or 09:24PM'
      t.time :closing_time, comment: 'Humanize the time like this: Time.now.strftime("%I:%M%p") => 09:24PM'
      t.integer :closing_days, array: true, null: false, default: [], comment: 'In these days the shop is closed, starting from Monday:0'
      t.string :social_links, array: true, default: []
      t.string :shop_website_url, comment: 'Online shop website url if exists.'
      t.belongs_to :seller, foreign_key: true

      t.timestamps
    end

    add_index :shops, :closing_days, using: 'gin'
    add_index :shops, :social_links, using: 'gin'

    # Website URL moved to shop
    remove_column :sellers, :website_url, :string
  end
end
