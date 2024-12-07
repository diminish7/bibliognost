class CreateWorkAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :work_authors do |t|
      t.references :work, index: false, foreign_key: true, null: false
      t.references :author, index: false, foreign_key: true, null: false
      t.timestamps

      t.index %i[work_id author_id], unique: true
    end
  end
end
