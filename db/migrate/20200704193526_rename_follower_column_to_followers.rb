class RenameFollowerColumnToFollowers < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :profiles, :follower, :followers
  end

  def self.down
    rename_column :profiles, :followers, :follower
  end
end
