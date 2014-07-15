class CreatingHydramataWorks < ActiveRecord::Migration
  def change
    create_table :hydramata_works_works, id: false do |t|
      t.string :pid, index: { unique: true }, null: false
      t.string :work_type, index: true, null: false
      t.text :properties, limit: 2147483647
      t.timestamps
    end
  end
end
