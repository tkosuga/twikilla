class DropBotsTable < ActiveRecord::Migration
  
  def self.up
    drop_table :bots
  end
  
  def self.down
  end
  
end
