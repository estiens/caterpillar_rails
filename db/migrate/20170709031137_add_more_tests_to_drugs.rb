class AddMoreTestsToDrugs < ActiveRecord::Migration[5.0]
  def change
    add_column :drugs, :folin_test, :string
    add_column :drugs, :robadope_test, :string
    add_column :drugs, :simons_test, :string
    add_column :drugs, :scott_test, :string
  end
end
