class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :line_id, null: false, index: true
      t.string :name, null: false, index: true

      t.timestamps
    end
  end
end
