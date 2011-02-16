class AddSpammerColumns < ActiveRecord::Migration
  
  extend MigrationHelpers 
  
  def self.up
    
    create_table :isnt_spammer_applications do |t|
      t.column :spammer_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.timestamps
    end
    
    foreign_key :isnt_spammer_applications, :spammer_id, :spammers
    add_index :isnt_spammer_applications, :spammer_id
    add_index :isnt_spammer_applications, :user_id
    
  end
  
  def self.down
  end
  
end
