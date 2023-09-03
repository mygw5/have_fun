class CreatePostTags < ActiveRecord::Migration[6.1]
  def change
    create_table :post_tags do |t|
      t.integer :post_hobby_id, null: false
      t.integer :tag_id,        null: false
      t.timestamps
    end
    add_index :post_tags, [:post_hobby_id, :tag_id], unique: true
  end
end
