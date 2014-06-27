class AddingItemPropSchemaDotOrgToPredicate < ActiveRecord::Migration
  def change
    add_column :hydramata_work_predicates, :itemprop_schema_dot_org, :string
  end
end
