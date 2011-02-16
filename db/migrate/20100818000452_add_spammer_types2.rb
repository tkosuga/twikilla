class AddSpammerTypes2 < ActiveRecord::Migration
  
  def self.up
    
    add_column :spammers, :rt_spammer, :boolean, :default => false, :null => false
    add_index :spammers, :rt_spammer
    
    Bot.destroy_all
    Bot.register_bots
    
  end
  
  def self.down
  end
end
