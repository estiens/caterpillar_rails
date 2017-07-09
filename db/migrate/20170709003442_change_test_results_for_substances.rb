class ChangeTestResultsForSubstances < ActiveRecord::Migration[5.0]
  def change
    remove_column :drugs, :test_kits, :string
    remove_column :drugs, :marquis, :string
    add_column :drugs, :marquis_test, :string
    add_column :drugs, :mandelin_test, :string
    add_column :drugs, :mecke_test, :string
    add_column :drugs, :liebermann_test, :string
    add_column :drugs, :froehde_test, :string
    add_column :drugs, :gallic_acid_test, :string
    add_column :drugs, :ehrlic_test, :string
  end
end
