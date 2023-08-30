class ChangeAgeTypeToInteger < ActiveRecord::Migration[7.0]
  def up
    change_column :customers, :age, :integer, using: 'age::integer'
  end

  def down
    change_column :customers, :age, :string
  end
end
