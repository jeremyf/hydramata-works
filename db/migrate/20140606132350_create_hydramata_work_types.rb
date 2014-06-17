class CreateHydramataWorkTypes < ActiveRecord::Migration
  def change
    create_table :hydramata_work_types do |t|
      t.string :identity, index: { unique: true }, null: false
      t.string :name_for_application_usage
      t.timestamps
    end
  end
end
