require 'rubygems'
require 'json'

require File.dirname(__FILE__)+'/../lib/base'
require File.dirname(__FILE__)+'/config'

class Fb < FacebookClient::Base
  
  def register
    rest_api.call 'admin.setAppProperties', :properties => {
      :application_name   => 'Facebook Client Test App',
      :callback_url       => ENV['FB_CALLBACK_URL']+'/',
      :connect_url        => ENV['FB_CALLBACK_URL']+'/',
      :iframe_enable_util => 1,
      :use_iframe         => 1
    }.to_json
  end
  
end