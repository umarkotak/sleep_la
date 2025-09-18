class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.uuid :guid, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :users, :guid, unique: true
  end
end
