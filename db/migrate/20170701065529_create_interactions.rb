class CreateInteractions < ActiveRecord::Migration[5.0]
  def change
    create_table :interactions do |t|
      t.references :substance_a, index: true
      t.references :substance_b, index: true
      t.string :status
      t.text :notes

      t.timestamps
    end

    add_index :interactions, [:substance_a_id, :substance_b_id], unique: true
  end
end
