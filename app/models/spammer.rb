class Spammer < ActiveRecord::Base
  
  has_many :isnt_spammer_applications
  has_many :is_spammer_applications
  
  named_scope :hashed_tag_spammers, lambda{|options|
    { :conditions => {:hashed_tag_spammer => true, :isnt_spammer => false}}.merge(options)
  }
  named_scope :ask_retweet_spammers, lambda{|options|
    { :conditions => {:ask_retweet_spammer => true, :isnt_spammer => false}}.merge(options)
  }
  named_scope :follow7_spammers, lambda{|options|
    { :conditions => {:follow7_spammer => true, :isnt_spammer => false}}.merge(options)
  }
  named_scope :automated_following_spammers, lambda{|options|
    { :conditions => {:automated_following_spammer => true, :isnt_spammer => false}}.merge(options)
  }
  named_scope :rt_spammers, lambda{|options|
    { :conditions => {:rt_spammer => true, :isnt_spammer => false}}.merge(options)
  }
  
  #
  # 以下のAPIから返される値からスパマーを生成します。
  # http://api.twitter.com/version/statuses/followers.format
  #
  def self.create_by_statuses_object(user)
    create_by(user.merge(
      "from_user_id" => user["id"], 
      "from_user" => user["screen_name"], 
      "iso_language_code" => user["lang"]
    ))
  end
  
  #
  # 以下のAPIから返される値からスパマーを生成します。
  # http://search.twitter.com/search.format
  #
  def self.create_by_search_object(item)
    create_by(item)
  end
  
  def self.create_by(item)
    #
    # userかuser_idで見つかれば、
    #
    spammer = Spammer.find_by_user(item["from_user"])
    spammer = Spammer.find_by_user_id(item["from_user_id"]) if spammer.blank?
    spammer = Spammer.new if spammer.blank?
    #
    # 属性を上書きする
    #
    spammer.user = item["from_user"]
    spammer.user_id = item["from_user_id"]
    spammer.iso_language_code = item["iso_language_code"]
    spammer.profile_image_url = item["profile_image_url"]
    spammer
  end
  
  def self.spammer_count
    Spammer.count(:conditions => {:isnt_spammer => false})
  end
  
  #
  # スパマーであるかを返します。
  # isnt_spammerがtrueであるか、isnt_spammer_applicationsが12以上であればスパマーではないと判定します。
  #
  def spammer?
    if (isnt_spammer == true || (isnt_spammer_applied_count - (is_spammer_applied_count*2))  > 12)
      false
    else
      true
    end
  end
  
  #
  # スパマーではない報告をカウントを返します。
  #
  def isnt_spammer_applied_count
    isnt_spammer_applications.count
  end
  
  #
  # スパマー報告をカウントを返します。
  #
  def is_spammer_applied_count
    is_spammer_applications.count
  end
  
  #
  # このスパマーに指定したユーザーからスパマーではない報告が来ました。
  # スパマーではない報告をカウントアップします。
  #
  def apply_isnt_spammer(user_id)
    application = IsntSpammerApplication.find(:first, :conditions => {:user_id => user_id, :spammer_id => id})
    if (application.blank?)
      application = IsntSpammerApplication.new(:user_id => user_id, :spammer_id => id)
      application.save!
    end
    application
  end
  
  #
  # このスパマーに指定したユーザーからスパマー報告が来ました。
  #
  def apply_is_spammer(user_id)
    application = IsSpammerApplication.find(:first, :conditions => {:user_id => user_id, :spammer_id => id})
    if (application.blank?)
      application = IsSpammerApplication.new(:user_id => user_id, :spammer_id => id)
      application.save!
    end
    application
  end
  
  #
  # 指定したユーザーがスパム/非スパム報告のどちらかでもしていればtrueを返します。
  # まだ両方行っていない場合にはfalseを返します。
  #
  def applied?(user_id)
    
    application = IsSpammerApplication.find(:first, :conditions => {:user_id => user_id, :spammer_id => id})
    return true if(application.present?)
    
    application = IsntSpammerApplication.find(:first, :conditions => {:user_id => user_id, :spammer_id => id})
    application.present?
    
  end
  
end
