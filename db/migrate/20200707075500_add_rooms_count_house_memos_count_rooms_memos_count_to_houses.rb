class AddRoomsCountHouseMemosCountRoomsMemosCountToHouses < ActiveRecord::Migration[5.2]
  def self.up
    add_column :houses, :rooms_count, :integer, null: false, default: 0

    add_column :houses, :house_memos_count, :integer, null: false, default: 0

    add_column :houses, :rooms_memos_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :houses, :rooms_count

    remove_column :houses, :house_memos_count

    remove_column :houses, :rooms_memos_count
  end
end
