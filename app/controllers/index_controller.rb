class IndexController < ApplicationController
  
  def index
  end
  
  def oauth
    
    #    if (session[:user_id])
    #      @customer = Customer.find_by_user_id(session[:user_id])
    #      render :action => :oauth_callback
    #      return
    #    end
    
    # :oauth_callbackに認証後のコールバックURLを指定
    # この場合だとこのコントローラー内の oauth_callback メソッドが実行される
    request_token = Auth.consumer.get_request_token(:oauth_callback => "http://#{request.host_with_port}/oauth_callback")
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    
    # twitter.comで認証する
    redirect_to request_token.authorize_url
    return
  end
  
  def oauth_callback
    
    # for production.
    token = access_token
    session[:user_id] = token.params[:user_id]
    @customer = Customer.new_customer(token)
    users = @customer.collect_automated_spammers_from_friends(2000)
    
    # for debug.
    #session[:user_id] = 76264861
    #@customer = Customer.find(:first, :conditions => {:user_id => 76264861})
    
    users = @customer.collect_automated_spammers_from_friends(100)
    
    if (users.blank?)
      raise SpammerCantDetectError.new("スパムユーザーが見つかりませんでした。フォローもしくはフォロワーの一覧が取得できない状態にある可能性があります。")
    end
    
    @spammers = @customer.detect_spammers
    
  end
  
  #
  # ajaxで呼び出される、スパマーから除外したい報告です。
  #
  def isnt_spammer
    spammer = Spammer.find(params[:spammer_id])
    spammer.apply_isnt_spammer(session[:user_id])
  end
  
  #
  # ajaxで呼び出される、スパマー報告です。
  #
  def is_spammer
    spammer = Spammer.find(params[:spammer_id])
    spammer.apply_is_spammer(session[:user_id])
  end
  
  private
  
  def access_token
    request_token = OAuth::RequestToken.new(Auth.consumer, session[:request_token], session[:request_token_secret])
    request_token.get_access_token({}, :oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])
  end
  
end