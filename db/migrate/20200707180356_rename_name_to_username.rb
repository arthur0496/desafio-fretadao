class RenameNameToUsername < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :profiles, :name, :username
  end

  def self.down
    rename_column :profiles, :username, :name
  end
end
