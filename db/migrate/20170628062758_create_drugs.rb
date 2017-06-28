class CreateDrugs < ActiveRecord::Migration[5.0]
  def change
    create_table :drugs do |t|
      t.string :name
      t.string :detection
      t.string :test_kits
      t.string :dose_summary
      t.string :onset_summary
      t.string :after_effects
      t.string :duration_summary
      t.text :effects, array: true, default: []
      t.text :aliases, array: true, default: []
      t.string :drug_summary
      t.text :categories, array: true, default: []
      t.string :detection
      t.string :marquis
      t.string :avoid
      t.string :general_advice
      t.json :full_response
      t.timestamps
    end
  end
end
