class CreateGroupUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_users do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false
      t.timestamps
    end
    add_index :group_users, [:group_id, :user_id], unique: true
  end
end
