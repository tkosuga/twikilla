class CreateBots < ActiveRecord::Migration
  
  def self.up
    
    create_table :bots  do |t|
      t.column :name, :string, :null => false
      t.column :email, :string, :null => false
      t.column :password, :string, :null => false
      t.column :token, :string
      t.column :secret, :string
      t.timestamps
    end
    

  end
  
  def self.down
    drop_table :bots
  end
  
end
