class CreateHydramataWorkPredicates < ActiveRecord::Migration
  def change
    create_table :hydramata_work_predicates do |t|
      t.string :identity, unique: true, index: true, null: false
      t.string :name_for_application_usage, null: false
      t.string :datastream_name, null: false
      t.string :value_coercer_name
      t.string :value_parser_name
      t.string :indexing_strategy
      t.timestamps
    end
  end
end
