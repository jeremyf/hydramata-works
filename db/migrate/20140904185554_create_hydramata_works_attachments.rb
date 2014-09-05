class CreateHydramataWorksAttachments < ActiveRecord::Migration
  def change
    create_table :hydramata_works_attachments, id: false do |t|
      t.string :pid, null: false
      t.string :work_id
      t.string :predicate
      t.string :file_uid
      t.string :file_name
      t.timestamps
    end
    add_index :hydramata_works_attachments, :pid, unique: true
    add_index :hydramata_works_attachments, :work_id
    add_index :hydramata_works_attachments, :predicate
  end
end
