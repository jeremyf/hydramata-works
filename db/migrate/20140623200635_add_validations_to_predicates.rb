class AddValidationsToPredicates < ActiveRecord::Migration
  def change
    add_column :hydramata_work_predicates, :validations, :text
  end
end
