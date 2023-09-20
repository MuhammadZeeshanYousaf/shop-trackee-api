class ChangeAddressDataType < ActiveRecord::Migration[7.0]
  # directly parsing :string to :jsonb gives PG::DatatypeMismatch error
  def up
    # drop old columns of type :string
    remove_column :shops, :address, :string

    # add new columns of type :datetime
    add_column    :shops, :address, :jsonb, default: {}, comment: 'Stores address in json as received from Google Map'
  end

  def down
    remove_column :shops, :address, :jsonb, default: {}
    add_column    :shops, :address, :string
  end
end
