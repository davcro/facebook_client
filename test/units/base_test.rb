require File.dirname(__FILE__)+'/../environment'
require 'shoulda'

class BaseTest < Test::Unit::TestCase
  
  context 'facebook client base' do
    setup do
      @fb = Fb.new
    end
    
    should 'have dynamic params' do
      assert_equal ENV['FB_SECRET'], @fb.secret
    end
    
    should 'create graph authenticator' do
      assert_instance_of FacebookClient::GraphAuthenticator, @fb.graph_authenticator
    end
    
    should 'create rest api instance' do
      assert_instance_of FacebookClient::RestApi, @fb.rest_api
    end
    
  end
  
end