class RenameUserTableToSpammerTable < ActiveRecord::Migration
  
  def self.up
    rename_table :users, :spammers
  end
  
  def self.down
  end
  
end
