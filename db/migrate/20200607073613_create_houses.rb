class CreateHouses < ActiveRecord::Migration[5.2]
  def change
    create_table :houses do |t|
      t.integer :user_id, null: false
      t.string 	:name, 		null: false

      t.timestamps
    end
  end
end
