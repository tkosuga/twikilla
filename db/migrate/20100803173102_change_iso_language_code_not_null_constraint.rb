class ChangeIsoLanguageCodeNotNullConstraint < ActiveRecord::Migration
  def self.up
    change_column :spammers, :iso_language_code, :string, :null => true
  end
  
  def self.down
  end
end
