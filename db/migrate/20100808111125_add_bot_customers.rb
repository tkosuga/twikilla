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
    customer = Customer.find_by_user_id("175631791")
    customer.destroy if (customer.present?)
    customer = Customer.new(:user_id => "175631791", :token => "175631791-jCAJU8Ytr8LITvDWz8CwTfe2aH28ZPOzzXwOnJVI", :secret => "jDS7pdB4qEeTzFHsazlR7sOuJT3aWjnAMduaSStbvM4")
    customer.save!
    Bot.new(:customer_id => customer.id).save!
    
    # twikilla_bot2
    customer = Customer.find_by_user_id("179144180")
    customer.destroy if (customer.present?)
    customer = Customer.new(:user_id => "179144180", :token => "179144180-OpqUKBePAHVgzBoHF3qcy5oPRoxTj8JtCiXnr0vF", :secret => "M6ZfcMFTZZkW7HHU3jS2fBxZJMFvzai4ef5biBQ")
    customer.save!
    Bot.new(:customer_id => customer.id).save!
    
    # twikilla_bot3
    customer = Customer.find_by_user_id("179144956")
    customer.destroy if (customer.present?)
    customer = Customer.new(:user_id => "179144956", :token => "179144956-m4yMRYHMFGj3fohEvHYcxfxBNAjJjb4H9voIgXEc", :secret => "UpDqmnOzeiNt8ZNOfbS9j1oAOjCUML5FFinbshbjTqc")
    customer.save!
    Bot.new(:customer_id => customer.id).save!
    
    # twikilla_bot4
    customer = Customer.find_by_user_id("179145592")
    customer.destroy if (customer.present?)
    customer = Customer.new(:user_id => "179145592", :token => "179145592-hjNfVfOh5lx9PvOkBN8jUhS6cjfwi2eiQUqUUvKZ", :secret => "OFMJaRYJwqq3VDxPuAOWSOo7RNKx04OnFW6eX1yeNsI")
    customer.save!
    Bot.new(:customer_id => customer.id).save!
    
  end
  
  def self.down
    drop_table :bots
  end
  
end
