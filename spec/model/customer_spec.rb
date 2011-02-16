require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Customer do
  
  before(:each) do
    Spammer.destroy_all
    Bot.destroy_all
    Customer.destroy_all
    Bot.register_bots
    Customer.new(:user_id => 8330352, :token => "76265048-QjwVJGqjlylbLm8GXzG84RZaBmb9HdxwEf3hkdxUW", :secret => "a0n8NTIoJMIFfCPPDL8geztlSRv6PT57gvajWSSo").save!
  end
  
  it "カスタマーを情報を返します" do
    customer = Customer.find_by_user_id(8330352)
    customer.profile["lang"].should eql "ja"
    customer.profile["name"].should eql "terukazu kosuga"
  end
  
  it "カスタマーからスパマーを全て返します。取得前は0です。" do
    customer = Customer.find_by_user_id(8330352)
    customer.detect_spammers.size.should eql 0
  end
  
  it "カスタマーからスパマーを全て返します。取得後は何件かあります。" do
    
    customer = Customer.find_by_user_id(8330352)
    
    spammers_from_followers = customer.collect_automated_spammers_from_followers(100)
    spammers_from_friends = customer.collect_automated_spammers_from_friends(100)
    
    spammers_from_followers.size.should satisfy {|v| v > 10}
    spammers_from_friends.size.should satisfy {|v| v > 10}
    
    customer.detect_spammers.size.should satisfy {|v| v > 50}
    
  end
  
  it "フォロワーの一覧を返します" do
    customer = Customer.find_by_user_id(8330352)
    customer.followers(200).size.should eql 200
  end
  
  it "フレンドの一覧を返します" do
    customer = Customer.find_by_user_id(8330352)
    customer.friends(200).size.should eql 200
  end
  
  after(:each) do
  end
  
end
