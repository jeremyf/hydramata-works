class CreateHydramataWorkTypes < ActiveRecord::Migration
  def change
    create_table :hydramata_works_types do |t|
      t.string :identity, null: false
      t.string :name_for_application_usage
      t.timestamps
    end
    add_index :hydramata_works_types, :identity, unique: true
    add_index :hydramata_works_types, :name_for_application_usage, unique: true
  end
end
