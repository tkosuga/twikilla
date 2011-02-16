class Auth
  
  APP_TOKEN = "UvRlIanj5i7pUeTF7bfA"
  APP_SECRET = "0GtlbOVtICXCvkjNsbCrGxbwGpqHcTPcgbEDmjpY"
  
  def self.consumer
    OAuth::Consumer.new(APP_TOKEN, APP_SECRET, { :site => "http://twitter.com" })
  end
  
  def self.consumer_by_gem_twitter
    Twitter::OAuth.new(Auth::APP_TOKEN, Auth::APP_SECRET)
  end
  
  def self.show_request_token_detail
    
    oauth = Twitter::OAuth.new(APP_TOKEN, APP_SECRET)
    request_token = oauth.request_token
    
    puts "request token: #{request_token.token}"
    puts "request secret: #{request_token.secret}"
    puts "authorize url: #{request_token.authorize_url}"
    
  end
  
  def self.show_access_token_detail(token, secret, pin)
    
    oauth = Twitter::OAuth.new(APP_TOKEN, APP_SECRET)
    oauth.authorize_from_request(token, secret, pin)
    
    at = oauth.access_token
    
    puts "access token: #{at.token}"
    puts "access secret: #{at.secret}"
    
  end
  
end
