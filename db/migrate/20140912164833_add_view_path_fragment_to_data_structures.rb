class AddViewPathFragmentToDataStructures < ActiveRecord::Migration
  def change
    add_column :hydramata_works_predicates, :view_path_fragment, :string, limit: 32
    add_column :hydramata_works_predicates, :translation_key_fragment, :string, limit: 32

    add_column :hydramata_works_types, :view_path_fragment, :string, limit: 32
    add_column :hydramata_works_types, :translation_key_fragment, :string, limit: 32

    add_column :hydramata_works_predicate_sets, :view_path_fragment, :string, limit: 32
    add_column :hydramata_works_predicate_sets, :translation_key_fragment, :string, limit: 32
  end
end
