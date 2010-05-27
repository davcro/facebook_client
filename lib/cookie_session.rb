module FacebookClient

  require 'rack'
  require 'digest'

  class CookieSession
  
    def self.create_and_secure(fb, cookies)
      cookie_session = new(fb, cookies)
    
      cookie_session.secure? ? cookie_session : nil
    end
  
    def initialize(fb, cookies)
      @fb=fb
      @data=parse_fbs!(cookies["fbs_#{fb.app_id}"])
    end
  
    def parse_fbs!(fbs)
      @data = fbs &&
        check_sig_and_return_data(Rack::Utils.parse_query(fbs[1..-2]))
    end
  
    def secure?
      @data.is_a?(Hash) and @data.has_key?('uid')
    end
  
    def uid
      @data['uid']
    end
  
    private
  
    def check_sig_and_return_data(cookies)
      cookies if calculate_sig(cookies) == cookies['sig']
    end
  
    def calculate_sig(cookies)
      args = cookies.reject{ |(k, v)| k == 'sig' }.sort.
        map{ |a| a.join('=') }.join

      Digest::MD5.hexdigest(args + @fb.secret)
    end
  
  end
  
end