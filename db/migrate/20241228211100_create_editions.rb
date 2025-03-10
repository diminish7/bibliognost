class CreateEditions < ActiveRecord::Migration[8.0]
  def change
    create_table :editions do |t|
      t.references :work, null: false, index: true, foreign_key: true
      t.references :language, null: true, index: true, foreign_key: true
      t.references :publisher, null: true, index: true, foreign_key: true

      t.string :title, null: false
      t.string :subtitle
      t.string :edition
      t.string :contributors, array: true, null: false, default: []
      t.string :external_identifier, null: false, index: { unique: true }

      t.string :isbn_10
      t.string :isbn_13

      t.date :published_at
      t.string :format
      t.integer :pages
      t.integer :word_count

      t.text :description

      t.timestamps
    end
  end
end
