class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.integer :owner_id,    null: false
      t.string  :group_name,  null: false
      t.text    :introduction,null: false
      t.timestamps
    end
    add_index :groups, :group_name, unique: true
  end
end
