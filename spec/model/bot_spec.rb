require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Bot do
  
  before(:each) do
    Spammer.destroy_all
    Bot.destroy_all
    Customer.destroy_all
    Bot.register_bots
  end
  
  it "ハッシュタグスパムを新しく取得します" do
    Bot.crawl_hashtag_spammer(10)
    Spammer.count.should_not eql 0
  end
  
  it "askリツイートのフォロワーは全員スパム登録します" do
    Bot.crawl_ask_retweet(100)
    Spammer.count.should eql 100
    Spammer.first.ask_retweet_spammer.should be_true
    Spammer.first.rt_spammer.should be_true
  end
  
  it "follow7のフォロワーは全員スパム登録します" do
    Bot.crawl_follow7(100)
    Spammer.count.should eql 100
    Spammer.first.automated_following_spammer.should be_true
    Spammer.first.follow7com_spammer.should be_true
  end
  
  after(:each) do
  end
  
end
