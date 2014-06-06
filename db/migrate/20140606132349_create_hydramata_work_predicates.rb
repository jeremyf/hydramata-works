class CreateHydramataWorkPredicates < ActiveRecord::Migration
  def change
    create_table :hydramata_work_predicates do |t|
      t.string :identity, unique: true, index: true, null: false
      t.string :name_for_application_usage, null: false
      t.string :default_datastream_name, null: false
      t.string :default_coercer_class_name, null: false
      t.string :default_parser_class_name, null: false
      t.string :default_indexing_strategy, null: false
      t.timestamps
    end
  end
end
