require 'openssl'
require File.dirname(__FILE__)+'/ext'

require File.dirname(__FILE__)+'/graph'
require File.dirname(__FILE__)+'/auth'
require File.dirname(__FILE__)+'/rest_api'
 
require File.dirname(__FILE__)+'/cookie_session'
require File.dirname(__FILE__)+'/iframe_session'
require File.dirname(__FILE__)+'/legacy_session'

module FacebookClient
  
  class Base
    
    GRAPH_URL = 'https://graph.facebook.com'
    
    attr_reader :params
    
    def initialize(default_params={})
      @params = default_params.reverse_merge({
        :app_id       => ENV['FB_APP_ID'],
        :api_key      => ENV['FB_API_KEY'],
        :secret       => ENV['FB_SECRET'],
        :canvas       => ENV['FB_CANVAS'],
        :callback_url => ENV['FB_CALLBACK_URL']
      })
    end
    
    def auth
      @auth ||= Auth.new(self)
    end
    
    def graph(token, expires = nil)
      Graph.new(self, token, expires)
    end

    def rest_api
      @rest_api ||= RestApi.new(self)
    end
    
    def method_missing(name, *args)
      if @params.has_key?(name)
        return @params[name]
      else
        super
      end
    end
    
  end
  
end