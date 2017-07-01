class AddSomeIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :drugs, :name
    add_index  :drugs, :aliases, using: 'gin'
  end
end
