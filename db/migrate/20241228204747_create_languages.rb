class CreateLanguages < ActiveRecord::Migration[8.0]
  def change
    create_table :languages do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :external_identifier, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
