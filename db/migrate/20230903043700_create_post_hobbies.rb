class CreatePostHobbies < ActiveRecord::Migration[6.1]
  def change
    create_table :post_hobbies do |t|
      t.integer :user_id
      t.string  :title
      t.text    :text
      t.integer :post_status
      t.timestamps
    end
  end
end
