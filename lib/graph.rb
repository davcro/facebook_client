require 'faraday'

module FacebookClient
  
  class ResponseError < StandardError; end
  
  class Graph
    
    attr_reader :access_token
    
    def initialize(fb, access_token, expires = nil)
      @fb           = fb
      @access_token = access_token
      expires       = 0 if expires.nil?
      expires       = expires.to_i
    end
    
    def get(path, params = {})
      params = params.stringify_keys
      params['access_token'] = @access_token
      response = connection.run_request(:get, path, nil, {}) do |request|
        request.params.update(params)
      end
      response = parse_response(response)
      return response
    end
    
    # {"error"=>{"message"=>"Error processing access token.", "type"=>"OAuthException"}}
    def parse_response(response)
      body = response.body
      if body.is_a?(Hash) and body.has_key?('error')
        raise ResponseError, "#{body['error']['message']}"
      end
      return body
    end
    
    def connection
      @connection ||= Faraday::Connection.new(:url => Base::GRAPH_URL) do |builder|
        builder.adapter :net_http
        builder.response :yajl
      end
    end

  end
  
end