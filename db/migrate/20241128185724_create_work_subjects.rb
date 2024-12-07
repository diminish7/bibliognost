class CreateWorkSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :work_subjects do |t|
      t.references :work, index: false, foreign_key: true, null: false
      t.references :subject, index: false, foreign_key: true, null: false
      t.timestamps

      t.index %i[work_id subject_id], unique: true
    end
  end
end
