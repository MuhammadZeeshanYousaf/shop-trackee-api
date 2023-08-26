class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :vocation
      t.string :gender
      t.string :age
      t.boolean :newsletter_subscribed, default: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
