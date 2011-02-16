class CreateCustomers < ActiveRecord::Migration
  
  extend MigrationHelpers 
  
  def self.up
    create_table :customers do |t|
      t.column :user_id, :integer, :null => false
      t.column :token, :string
      t.column :secret, :string
      t.timestamps
    end
    
    add_index :customers, :user_id, :unique => true
    
  end
  
  def self.down
    drop_table :customers
  end
end
