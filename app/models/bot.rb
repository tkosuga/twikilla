class Bot < ActiveRecord::Base
  
  belongs_to :customer
  
  #
  # ハッシュタグスパムを行っているユーザーをスパム登録して行きます。
  # 定期的に特定ハッシュタグの検索を行い100件取得します。
  #
  def self.crawl_hashtag_spammer(per_page = 100)
    
    tags = %w(followme followmejp sougofollow followback followdaibosyu amazon meigen)
    tags.each{|tag|
      Twitter::Search.new.hashed(tag).per_page(per_page).each{|item|
        spammer = Spammer.create_by_search_object(item)
        spammer["hashtag_spam_count"] += 1
        spammer["hashed_tag_spammer"] = true if spammer["hashtag_spam_count"] > 7
        spammer.save!
      }
    }
    
  end
  
  #
  # Ask retweeetに登録しているユーザーを全てスパム登録します。
  # Ask retweeetはRT拡散を目的とした悪質なスパム発信源です。
  #
  # http://re-tweet.net/index.php
  #
  def self.crawl_ask_retweet(max = 2000)
    
    crawl_followers_by_screen_name("retweet_jp", max){|spammer|
      spammer.rt_spammer = true
      spammer.ask_retweet_spammer = true
    }
    
  end
  
  #
  # follow7に登録しているユーザーを全てスパム登録します。
  # follow7は自動相互フォローを目的とした悪質なスパム発信源です。
  #
  # http://follow7.com/
  #
  def self.crawl_follow7(max = 2000)
    
    crawl_followers_by_screen_name("follow7com", max){|spammer|
      spammer.automated_following_spammer = true
      spammer.follow7com_spammer = true
    }
    
  end
  
  #
  # 指定したscreen_nameのフォロワーを全てスパマー登録します。
  #
  # フォロワーの取得上限をmaxで指定できます。デフォルトは2000です。
  # per_pageは100件になるので、例えば1000フォロワーを取得する場合にはAPIを10消費します。
  #
  # ブロックには取得したフォロワーを順に全て渡します。
  #
  def self.crawl_followers_by_screen_name(screen_name, max = 2000, &block)
    
    customer = detect_bot.customer
    
    users = customer.followers(max, :screen_name => screen_name)
    customer.register_spammers_from_users(users, &block)
    
    users
    
  end
  
  #
  # 複数あるbotの1つをランダムで返します。
  # 簡易に自然な負荷分散を期待するためです。
  #
  def self.detect_bot
    
    user_id = [
      "175631791", # twikilla_bot1
      "179144180", # twikilla_bot2
      "179144956", # twikilla_bot3
      "179145592"  # twikilla_bot4
    ].sort_by{rand}.first
    
    Customer.find_by_user_id(user_id).bot
    
  end
  
  #
  # 全てのBOTを登録しなおします。
  # Customerモデル、Botモデルのインテグレーションで内容が失われた後に復元するためにあります。
  #
  def self.register_bots
    
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
  
end
