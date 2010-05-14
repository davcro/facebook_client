module FacebookClient
  
  class ResponseError < StandardError; end
  
  require 'digest'
  require 'faraday'
  
  class RestApi
    
    def initialize(fb)
      @fb = fb
    end
    
    def call(method, params={})
      params[:format]  = 'JSON'
      params[:v]       = '1.0'
      params[:method]  = 'facebook.' + method
      params[:call_id] = Time.now.to_f.to_s
      params[:timeout] ||= 8 # seconds
      params[:api_key] = @fb.api_key
      
      timeout = params.delete(:timeout)

      raw_string = params.inject([]) { |args, pair| args << pair.join('=') }.sort.join
      params[:sig] = Digest::MD5.hexdigest(raw_string + @fb.secret)
      
      response = connection.post do |request|
        request.body = params
      end
      response.body
    end
    
    def connection
      @connection ||= Faraday::Connection.new(:url => 'http://api.facebook.com/restserver.php') do |builder|
        builder.adapter :net_http
        builder.response :yajl
      end
    end
    
  end
  
end