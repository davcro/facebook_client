require 'faraday'

module FacebookClient
  
  class GraphAccess
    
    attr_reader :access_token
    
    def initialize(fb, access_token, expires=nil)
      @fb=fb
      @access_token=access_token
      if expires.nil?
        expires=0
      end
      expires=expires.to_i
    end

    def get(path, params={})
      params = params.stringify_keys
      params['access_token'] = @access_token
      resp = connection.run_request(:get, path, nil, {}) do |request|
        request.params.update(params)
      end
      resp.body
    end

    def connection
      @connection ||= Faraday::Connection.new(:url => Base::GRAPH_URL) do |builder|
        builder.adapter :net_http
        builder.response :yajl
      end
    end

  end
  
end