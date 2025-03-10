# frozen_string_literal: true

class CreateEditionAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :edition_authors do |t|
      t.references :edition, index: false, foreign_key: true, null: false
      t.references :author, index: false, foreign_key: true, null: false
      t.timestamps

      t.index %i[edition_id author_id], unique: true
    end
  end
end
