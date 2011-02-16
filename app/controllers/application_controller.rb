# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  #
  # ツイッターで異常が起こったときに利用する例外です。
  # タイムラインが取れない、リスト機能が消えた、フォローフォロワー数が0になった、
  # などの予期せぬ不具合が起こっただろうデータが取得された場合に利用します。
  #
  class TwitterAbnormalStatusException < StandardError; end
  
  # 
  # スパムユーザーが見つかりませんでした。最低1名は候補として挙がってくるはずです。
  # 
  class SpammerCantDetectError < TwitterAbnormalStatusException; end
  
  def rescue_action(exception)
    
    logging_exception_detail(exception)
    
    @original_exception = exception 
    case exception
      when OAuth::Unauthorized
      @error_message = "認証に失敗しました。"
      
      when Twitter::RateLimitExceeded 
      @error_message = "利用制限の上限に達しています。"
      
      when Twitter::Unauthorized
      @error_message = "認証に失敗しました。"
      
    else
      @error_message = "エラーが発生しました。"
    end
    
    render :template => "index/error", :status => 500, :locals => {
      :error_message => @error_message,
      :original_exception => @original_exception
    }
    
  rescue => e
    logging_exception_detail(e)
    
    @original_exception = e 
    @error_message = "エラーが発生しました。"
    
    render :template => "index/error", :status => 500, :locals => {
      :error_message => @error_message,
      :original_exception => @original_exception
    }
  end
  
  def logging_exception_detail(e)
    logger.fatal("\n\n#{e.class} (#{e.message}):\n    " + clean_backtrace(e).join("\n    ") + "\n\n")
  end
  
  def clean_backtrace(exception)
    if backtrace = exception.backtrace
      if defined?(RAILS_ROOT)
        backtrace.map { |line| line.sub RAILS_ROOT, '' }
      else
        backtrace
      end
    end
  end
  
end
