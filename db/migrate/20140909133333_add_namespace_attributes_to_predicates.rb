class AddNamespaceAttributesToPredicates < ActiveRecord::Migration
  def change
    add_column :hydramata_works_predicates, :namespace_context_prefix , :string
    add_column :hydramata_works_predicates, :namespace_context_url , :string
    add_column :hydramata_works_predicates, :namespace_context_name , :string
  end
end
