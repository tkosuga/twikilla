class AddBotCustomers < ActiveRecord::Migration
  
  extend MigrationHelpers 
  
  def self.up
    
    create_table :bots  do |t|
      t.column :customer_id, :integer, :null => false
      t.timestamps
    end
    
    foreign_key :bots, :customer_id, :customers
    add_index :bots, :customer_id
    
    # twikilla_bot1
    # twikilla_bot2
    # twikilla_bot3
    # twikilla_bot4
    
  end
  
  def self.down
    drop_table :bots
  end
  
end
