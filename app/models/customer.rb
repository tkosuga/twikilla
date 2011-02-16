class Customer < ActiveRecord::Base
  
  PER_PAGE = 100
  
  has_one :bot
  
  def self.new_customer(access_token)
    #
    # 既に存在する場合には処理をスルーする。
    #
    customer = Customer.find_by_user_id(access_token.params[:user_id])
    customer.destroy if (customer.present?)
    
    customer = Customer.new(:user_id => access_token.params[:user_id], :token => access_token.token, :secret => access_token.secret)
    customer.oauth
    customer.save!
    customer
  end
  
  def oauth
    a = Auth.consumer_by_gem_twitter
    a.authorize_from_access(token, secret) # ログアウトされているユーザーはここでエラーが返されるはず
    a
  end
  
  def client
    return @client if (defined?(@client))
    @client = Twitter::Base.new(oauth) 
  end
  
  def profile
    return @profile if defined?(@profile)
    @profile = client.user(user_id)
  end
  
  #
  # このユーザーのフォロワー一覧を返します。
  #
  def followers(max, query = {})
    fetch(:followers, "users", max, query)
  end
  
  #
  # このユーザーのフレンド一覧を返します。
  #
  def friends(max, query = {})
    fetch(:friends, "users", max, query)
  end
  
  #
  # このユーザーのフォロワーID一覧を返します。
  #
  def follower_ids
    return @follower_ids if defined?(@follower_ids)
    @follower_ids = client.follower_ids
  end
  
  #
  # このユーザーのフレンドID一覧を返します。
  #
  def friend_ids
    return @friend_ids if defined?(@friend_ids)
    @friend_ids = client.friend_ids
  end
  
  #
  # スパムをやっているフレンドの一覧をSpammerクラスで返します。
  # 新しいスパマーの取得は行いません。既に登録されているスパマーから判定を行います。
  #
  # 新しくスパマー登録を行い、最新のスパマーを取得する場合には
  # 以下の2つのメソッドを呼び出した後に、このメソッドを呼んでください。
  #
  # collect_automated_spammers_from_followers(max)
  # collect_automated_spammers_from_friends(max)
  #
  # Spammer#spammer?でtrueのスパマーのみを返します。
  #
  def detect_spammers
    
    conditions = {:conditions => {:user_id => friend_ids}, :select => [:user_id]}
    
    ids = 
     (Spammer.hashed_tag_spammers(conditions).collect{|m| m.user_id}) + 
     (Spammer.automated_following_spammers(conditions).collect{|m| m.user_id}) +
     (Spammer.rt_spammers(conditions).collect{|m| m.user_id})
    
    Spammer.find(:all, :conditions => {:user_id => ids.uniq}).select{|spammer|
      spammer.spammer?
    }
    
  end
  
  #
  # フォロースパムをやっているスパマーの一覧をSpammerクラスで返します。
  #
  def collect_automated_spammers_from_followers(max)
    collect_spammers_from_users(followers(max))
  end
  
  #
  # フォロースパムをやっているスパマーの一覧をSpammerクラスで返します。
  #
  def collect_automated_spammers_from_friends(max)
    collect_spammers_from_users(friends(max))
  end
  
  #
  # 指定したユーザーの中で、フォロースパムをやっているスパマーの一覧をSpammerクラスで返します。
  #
  def collect_spammers_from_users(users)
    users = users.reject{|user|
      #
      # フォロワーが10万人超えているものは除外する
      #
      user["followers_count"] > 100_000 
    }.select{|user|
      #
      # フォローとフォロワーが5000人超えているものを収集する
      #
      user["friends_count"] > 5_000 && user["followers_count"] > 5_000
    }.select{|user|
      #
      # フォローとフォロワーのバランスが0.8から1.2にあるものを収集する
      #
      raito = user["friends_count"].to_f / user["followers_count"].to_f
      raito < 1.20 && raito > 0.80
    }
    register_spammers_from_users(users){|spammer|
      spammer.automated_following_spammer = true
    }
    
  end
  
  #
  # 指定したユーザーの一覧をスパマー登録します。
  #
  def register_spammers_from_users(users, &block)
    users.each{|user|
      register_spammer(user, &block)
    }
  end
  
  #
  # 指定したuserをスパマー登録します。
  #
  def register_spammer(user)
    spammer = Spammer.create_by_statuses_object(user)
    spammer["friends_count"] = user["friends_count"]
    spammer["followers_count"] = user["followers_count"]
    yield(spammer)
    spammer.save!
    spammer
  end
  
  def fetch(method, array_name, max, query = {})
    
    items = []
    next_cursor = -1
    
    begin
      query['cursor'] = next_cursor
      client.__send__(method, query).each{|key, value|
        if key == array_name
          items += value
        elsif key == "next_cursor"
          next_cursor = value.to_i
        end
      }
    end while next_cursor > 0 && items.size < max
    
    items[0..(max - 1)]
    
  end
  
end
