class AddSpammerColumns2 < ActiveRecord::Migration
  
  extend MigrationHelpers 
  
  def self.up
    
    create_table :is_spammer_applications do |t|
      t.column :spammer_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.timestamps
    end
    
    foreign_key :is_spammer_applications, :spammer_id, :spammers
    add_index :is_spammer_applications, :spammer_id
    add_index :is_spammer_applications, :user_id
    
  end
  
  def self.down
  end
  
end
