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
    
    Bot.new(:name => "地域ッター西日本", :email => "tkosug.a@gmail.com", :password => "SFSa9ghD", :token => "76264861-GHp4PtPioBmPp90vxjBc6jMSkdyWSP6CnZgir1f3B", :secret => "YzqOuvczOosvv59K9ut9umYSH9hnGLU9tl0WQYDCum4").save!
    Bot.new(:name => "地域ッター東日本", :email => "tkosu.ga@gmail.com", :password => "5o15YcCr", :token => "76265048-QjwVJGqjlylbLm8GXzG84RZaBmb9HdxwEf3hkdxUW", :secret => "a0n8NTIoJMIFfCPPDL8geztlSRv6PT57gvajWSSo").save!
    
  end
  
  def self.down
    drop_table :bots
  end
  
end
