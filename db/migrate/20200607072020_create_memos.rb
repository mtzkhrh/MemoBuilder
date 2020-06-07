class CreateMemos < ActiveRecord::Migration[5.2]
  def change
    create_table :memos do |t|
      t.integer :user_id, null: false
      t.integer :house_id
      t.integer :room_id
      t.string  :title, null: false
      t.text    :body,  null: false
      t.integer :range, default: 0
      t.string  :image_id

      t.timestamps
    end
  end
end
