require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Spammer do
  
  before(:each) do

    Spammer.destroy_all
    Bot.destroy_all
    Customer.destroy_all
    Bot.register_bots
    
    user1 = {
      "user_id" => "from_user_id_1".hash,
      "user" => "from_user_1",
      "iso_language_code"  => "ja",
      "profile_image_url"  => "profile_image_url_1",
      "hashtag_spam_count" => 1,
    }
    #
    # ハッシュタグスパム。
    #
    user2 = {
      "user_id" => "from_user_id_2".hash,
      "user" => "from_user_2",
      "iso_language_code"  => "ja",
      "profile_image_url"  => "profile_image_url_2",
      "hashtag_spam_count" => 10,
      "hashed_tag_spammer" => true,
    }
    #
    # ハッシュタグスパム。
    #
    user3 = {
      "user_id" => "from_user_id_3".hash,
      "user" => "from_user_3",
      "iso_language_code"  => "zh",
      "profile_image_url"  => "profile_image_url_3",
      "hashtag_spam_count" => 20,
      "hashed_tag_spammer" => true,
    }
    #
    # 自動フォロースパム。
    #
    user4 = {
      "user_id" => "from_user_id_4".hash,
      "user" => "from_user_4",
      "iso_language_code" => "zh",
      "profile_image_url" => "profile_image_url_4",
      "friends_count"     => 20000,
      "followers_count"   => 20000,
      "automated_following_spammer" => true,
    }
    user5 = {
      "user_id" => "from_user_id_5".hash,
      "user" => "from_user_5",
      "iso_language_code" => "zh",
      "profile_image_url" => "profile_image_url_5",
      "friends_count"     => 100,
      "followers_count"   => 20000,
    }
    #
    # ハッシュタグと自動フォロースパム。
    #
    user6 = {
      "user_id" => "from_user_id_6".hash,
      "user" => "from_user_6",
      "iso_language_code" => "zh",
      "profile_image_url" => "profile_image_url_6",
      "friends_count"     => 100,
      "followers_count"   => 20000,
      "hashtag_spam_count"=> 10,
      "hashed_tag_spammer" => true,
      "automated_following_spammer" => true,
    }
    
    Spammer.new(user1).save!
    Spammer.new(user2).save!
    Spammer.new(user3).save!
    Spammer.new(user4).save!
    Spammer.new(user5).save!
    Spammer.new(user6).save!
    
  end
  
  
  it "http://search.twitter.com/search.formatから返されるユーザー情報でユーザーを作成します" do
    
    item = {
      "from_user_id"      => "from_user_id_x".hash,
      "from_user"         => "from_user_x",
      "iso_language_code" => "zh",
      "profile_image_url" => "profile_image_url_x",
    }
    
    user = Spammer.create_by_search_object(item)
    user[:user_id].should eql "from_user_id_x".hash
    user[:user].should eql "from_user_x"
    user[:iso_language_code].should eql "zh"
    user[:profile_image_url].should eql "profile_image_url_x"
    user[:hashtag_spam_count].should eql 0
    
  end
  
  it "http://api.twitter.com/version/statuses/followers or friendsから返されるユーザー情報でユーザーを作成します" do
    
    item = {
      "id" => "from_user_id_x".hash,
      "screen_name" => "from_user_x",
      "lang" => "zh",
      "profile_image_url" => "profile_image_url_x",
    }
    
    user = Spammer.create_by_statuses_object(item)
    user[:user_id].should eql "from_user_id_x".hash
    user[:user].should eql "from_user_x"
    user[:iso_language_code].should eql "zh"
    user[:profile_image_url].should eql "profile_image_url_x"
    user[:hashtag_spam_count].should eql 0
    
  end
  
  it "スパマー数を取得できます" do
    Spammer.spammer_count.should eql 6
  end
  
  after(:each) do
  end
  
end
