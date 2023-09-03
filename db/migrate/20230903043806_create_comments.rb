class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :post_hobby_id
      t.string  :comment
      t.timestamps
    end
  end
end
