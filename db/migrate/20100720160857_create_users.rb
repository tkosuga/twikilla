class CreateUsers < ActiveRecord::Migration
  def self.up
    
    create_table :users  do |t|
      t.column :user_id, :integer, :null => false
      t.column :user, :string, :null => false
      t.column :profile_image_url, :string
      t.column :hashtag_spam_count, :integer, :null => false, :default => 0
      t.column :followers_count, :integer, :null => false, :default => 0
      t.column :friends_count, :integer, :null => false, :default => 0
      t.column :iso_language_code, :string, :null => false
      t.timestamps
    end
    
    add_index :users, :user_id, :unique => true
    add_index :users, :user, :unique => true
    add_index :users, :iso_language_code
    
  end
  
  def self.down
    drop_table :users
  end
end
