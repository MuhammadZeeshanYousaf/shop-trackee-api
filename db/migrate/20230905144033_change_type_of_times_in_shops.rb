class ChangeTypeOfTimesInShops < ActiveRecord::Migration[7.0]
  # Change type to resolve conflict in getting datetime from frontend app
  # directly parsing :time to :datetime gives PG::DatatypeMismatch error

  def up
    # drop old columns of type :time
    remove_column :shops, :closing_time, :time
    remove_column :shops, :opening_time, :time

    # add new columns of type :datetime
    add_column :shops, :closing_time, :datetime
    add_column :shops, :opening_time, :datetime
  end

  def down
    change_column :shops, :closing_time, :time
    change_column :shops, :opening_time, :time
  end
end
