class AddAutomatedFollowingSpammerColumn < ActiveRecord::Migration
  
  def self.up
    
    add_column :spammers, :hashed_tag_spammer, :boolean, :default => false, :null => false
    add_column :spammers, :automated_following_spammer, :boolean, :default => false, :null => false
    add_column :spammers, :ask_retweet_spammer, :boolean, :default => false, :null => false
    add_column :spammers, :isnt_spammer, :boolean, :default => false, :null => false
    
    add_index :spammers, :hashed_tag_spammer
    add_index :spammers, :automated_following_spammer
    add_index :spammers, :ask_retweet_spammer
    add_index :spammers, :isnt_spammer
    
  end
  
  def self.down
  end
  
end
