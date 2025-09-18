class CreateUserFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :user_follows do |t|
      t.references :from_user, null: false, foreign_key: { to_table: :users }
      t.references :to_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    # One unique follow pair
    add_index :user_follows, [ :from_user_id, :to_user_id ], unique: true, using: :btree
  end
end
