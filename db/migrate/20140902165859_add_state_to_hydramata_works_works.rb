class AddStateToHydramataWorksWorks < ActiveRecord::Migration
  def change
    add_column :hydramata_works_works, :state, :string, limit: 32, null: false, default: 'unknown'
    add_index :hydramata_works_works, :state
  end
end
