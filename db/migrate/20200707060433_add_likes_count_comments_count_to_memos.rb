class AddLikesCountCommentsCountToMemos < ActiveRecord::Migration[5.2]
  def self.up
    add_column :memos, :likes_count, :integer, null: false, default: 0

    add_column :memos, :comments_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :memos, :likes_count

    remove_column :memos, :comments_count
  end
end
