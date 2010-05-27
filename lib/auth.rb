require 'faraday'
require 'rack'

module FacebookClient
  
  class ResponseError < StandardError; end
  
  class Auth
    
    def initialize(fb)
      @fb=fb
    end

    def url(params={})
      # params
      #  - scope
      #  - redirect_uri
      params = params.stringify_keys
      params['client_id'] = @fb.app_id
      params.require_keys('redirect_uri', 'client_id')
      connection.build_url('/oauth/authorize', params).to_s
    end

    def request_access(params={})
      # required params
      # - code
      # - redirect_uri
      response = connection.get(access_token_url(params))
      data = Rack::Utils.parse_query(response.body)
      validate_access_token_response(data)
      @fb.graph(data['access_token'], data['expires'])
    end
    
    def validate_access_token_response(data)
      if !data.is_a?(Hash)
        raise ResponseError, "response must be a hash"
      end
      data = data.stringify_keys
      missing_keys = ['access_token']-data.keys 
      if missing_keys.size>0
        raise ResponseError, "response missing key(s) #{missing_keys.join(', ')}"
      end
    end
    
    def access_token_url(params={})
      params = params.stringify_keys
      params['client_id']     = @fb.app_id
      params['client_secret'] = @fb.secret
      params.require_keys('redirect_uri', 'client_id', 'client_secret', 'code')
      params.assert_valid_keys('redirect_uri', 'client_id', 'client_secret', 'code')
      connection.build_url('/oauth/access_token', params).to_s
    end
        
    def connection
      @connection ||= Faraday::Connection.new(:url => Base::GRAPH_URL) do |builder|
        builder.adapter :net_http
      end
    end

  end
end