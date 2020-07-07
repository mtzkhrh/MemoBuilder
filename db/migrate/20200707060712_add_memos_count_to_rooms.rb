class AddMemosCountToRooms < ActiveRecord::Migration[5.2]
  def self.up
    add_column :rooms, :memos_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :rooms, :memos_count
  end
end
