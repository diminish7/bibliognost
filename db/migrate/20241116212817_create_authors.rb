class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.string :external_identifier, index: { unique: true }

      t.timestamps
    end
  end
end
