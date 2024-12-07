class CreateWorks < ActiveRecord::Migration[8.0]
  def change
    create_table :works do |t|
      t.string :title, null: false
      t.string :external_identifier, index: { unique: true }

      t.timestamps
    end
  end
end
