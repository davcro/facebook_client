require File.dirname(__FILE__)+'/../../environment'

require 'shoulda'
require 'rr'

class SignedRequestParamTest < Test::Unit::TestCase
  
  include RR::Adapters::TestUnit
  
  context 'Signed Request' do
    setup do
      # sample fb data from july 29, 2010
      # {"signed_request"=>"3A-xn0w2unKg-emKuBTQllbarTT0avanXY8RKtOvr8M.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEyODA0NzMyMDAsIm9hdXRoX3Rva2VuIjoiMTI4MjA1OTUwNTI0MjA5fDIuUnVBNl9xb0VneTNraDF3ZTJrbEFHZ19fLjM2MDAuMTI4MDQ3MzIwMC0xNzQ3MTA4MzIzfG9sNml4Yi1KZ013X2JEODhhSEltcVdfWXFYdy4iLCJ1c2VyX2lkIjoiMTc0NzEwODMyMyJ9" }
      @fb = Fb.new(
        :secret => '023a7be83f2decb9e6e103fcbca9dad0'
      )
      @signed_request = "3A-xn0w2unKg-emKuBTQllbarTT0avanXY8RKtOvr8M.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEyODA0NzMyMDAsIm9hdXRoX3Rva2VuIjoiMTI4MjA1OTUwNTI0MjA5fDIuUnVBNl9xb0VneTNraDF3ZTJrbEFHZ19fLjM2MDAuMTI4MDQ3MzIwMC0xNzQ3MTA4MzIzfG9sNml4Yi1KZ013X2JEODhhSEltcVdfWXFYdy4iLCJ1c2VyX2lkIjoiMTc0NzEwODMyMyJ9"
      @uid = '1747108323'
      @access_token = '128205950524209|2.RuA6_qoEgy3kh1we2klAGg__.3600.1280473200-1747108323|ol6ixb-JgMw_bD88aHImqW_YqXw.'
      @params = {
        "signed_request" => @signed_request
      }
      @session = FacebookClient::Session::SignedRequestParam.create_and_secure(@fb, @params)
    end
    
    should "verify signed request" do
      assert FacebookClient::Session::SignedRequestParam.verify_signed_request(@fb.secret, @params["signed_request"])
      assert_equal @uid, FacebookClient::Session::SignedRequestParam.parse_params(@params["signed_request"])["user_id"]
    end
    
    should 'accept valid params' do
      @session = FacebookClient::Session::SignedRequestParam.create_and_secure(@fb, @params)
      assert_equal @uid, @session.uid
    end
    
    should "create a valid Graph instance with an access token" do
      graph = @session.graph
      assert_not_nil graph
      assert_equal @access_token, graph.access_token
    end
  end
  
end