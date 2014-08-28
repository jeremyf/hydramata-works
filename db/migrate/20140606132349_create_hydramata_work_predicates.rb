class CreateHydramataWorkPredicates < ActiveRecord::Migration
  def change
    create_table :hydramata_works_predicates do |t|
      t.string :identity, null: false
      t.string :name_for_application_usage
      t.string :datastream_name
      t.string :value_coercer_name
      t.string :value_parser_name
      t.string :indexing_strategy
      t.timestamps
    end
    add_index :hydramata_works_predicates, :identity, unique: true
    add_index :hydramata_works_predicates, :name_for_application_usage, unique: true
  end
end
