class AddMemosCountToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :memos_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :memos_count
  end
end
