class AddSpammerTypes < ActiveRecord::Migration
  
  def self.up
    
    add_column :spammers, :follow7com_spammer, :boolean, :default => false, :null => false
    add_index :spammers, :follow7com_spammer
    
  end
  
  def self.down
  end
end
