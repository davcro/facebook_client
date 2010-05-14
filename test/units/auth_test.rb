require File.dirname(__FILE__)+'/../environment'
require 'shoulda'
require 'rr'
require 'cgi'
require 'faraday'
class AuthTest < Test::Unit::TestCase
  
  include RR::Adapters::TestUnit
  
  context 'fb authenticator' do
    setup do
      @fb = Fb.new
      @auth = @fb.auth
      @redirect_uri = ENV['FB_CALLBACK_URL']+'/fb/auth/callback'
      @code = '1234'
    end
    
    should 'create url' do
      scope = 'email'
      url = @auth.url(
        :scope => scope,
        :redirect_uri => @redirect_uri
      )
      assert url.include?(FacebookClient::Base::GRAPH_URL)
      assert url.include?('scope=email')
      assert url.include?("redirect_uri=#{CGI.escape(@redirect_uri)}")
      assert url.include?("client_id=#{@fb.app_id}")
    end
    
    should 'create access token url' do
      @access_url = @auth.access_token_url(
        :redirect_uri => @redirect_uri,
        :code         => @code
      )
      [ "code=#{CGI.escape(@code)}", "redirect_uri=#{CGI.escape(@redirect_uri)}", "client_secret=#{@fb.secret}" ].each do |url_string|
        assert @access_url.include?(url_string)
      end
    end
    
    should 'get access' do
      @access_token = '2.mqSf8VbjxcdKaZP54tucrw__.3600.1273809600-1747108323|YwW6tqsjhzXHV_SjP-UNHessE4U.'
      stub(@auth.connection).get(anything) {
        stub(Object.new).body { "access_token=#{@access_token}&expires=0" }
      }
      graph_access = @auth.request_access( :code => @code, :redirect_uri => @redirect_uri )
      assert_equal @access_token, graph_access.access_token
    end
    
  end
  
end