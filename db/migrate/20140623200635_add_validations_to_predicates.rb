class AddValidationsToPredicates < ActiveRecord::Migration
  def change
    add_column :hydramata_works_predicates, :validations, :text
  end
end
