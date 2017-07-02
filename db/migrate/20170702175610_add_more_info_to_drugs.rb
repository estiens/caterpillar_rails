class AddMoreInfoToDrugs < ActiveRecord::Migration[5.0]
  def change
    add_column :drugs, :toxicity_info, :string
    add_column :drugs, :chemical_class, :string
    add_column :drugs, :addiction_potential, :string
    add_column :drugs, :cross_tolerance, :string
    add_column :drugs, :time_to_full_tolerance, :string
    add_column :drugs, :time_to_zero_tolerance, :string
  end
end
