require File.dirname(__FILE__)+'/../environment'
require 'shoulda'
require 'rr'

class GraphTest < Test::Unit::TestCase
  
  include RR::Adapters::TestUnit
  
  context 'graph' do
    setup do
      @access_token = '2.mqSf8VbjxcdKaZP54tucrw__.3600.1273809600-1747108323|YwW6tqsjhzXHV_SjP-UNHessE4U.'
      @fb = Fb.new
      @access = @fb.graph(@access_token)
    end
    
    should 'process response errors' do
      response = Object.new
      stub(response).body { {"error"=>{"message"=>"Error processing access token.", "type"=>"OAuthException"}} }
      assert_raise FacebookClient::ResponseError do
        @access.parse_response(response)
      end
    end
    
  end
  
end