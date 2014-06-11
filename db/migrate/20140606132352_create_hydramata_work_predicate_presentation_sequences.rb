class CreateHydramataWorkPredicatePresentationSequences < ActiveRecord::Migration
  def change
    create_table :hydramata_work_predicate_presentation_sequences do |t|
      t.integer :predicate_set_id, index: true, null: false
      t.integer :predicate_id, index: true, null: false
      t.integer :presentation_sequence, index: true, null: false
      t.timestamps
    end
    add_index :hydramata_work_predicate_presentation_sequences, [:predicate_set_id, :predicate_id], unique: true, name: :hydramata_work_predicate_presentation_sequences_identity
    add_index :hydramata_work_predicate_presentation_sequences, [:predicate_set_id, :presentation_sequence], unique: true, name: :hydramata_work_predicate_presentation_sequences_presentation
  end
end
