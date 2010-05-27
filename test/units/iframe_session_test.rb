require File.dirname(__FILE__)+'/../environment'

require 'shoulda'
require 'rr'

class IframeSessionTest < Test::Unit::TestCase
  
  include RR::Adapters::TestUnit
  
  context 'IframeSession' do
    setup do
      @fb = Fb.new(
        :app_id => 123,
        :secret => "3d5b507696ec366adb8edb96e41eb971"
      )
    end
    should 'accept valid params' do
      params = {
        "session" => "{\"uid\":\"1747108423\",\"session_key\":\"906ca6b312bf08b11c65297c-1747108323\",\"secret\":\"23d2d5441174b8ab0db12683dd88c576\",\"expires\":0,\"access_token\":\"128205950524209|906ca6b312bf08b11c65297c-1747108323|zMrZh_xC_w_5K1hhf3dOiGWK20Q.\",\"sig\":\"1c68c53be1eff6b4171bc2bca6c9f071\"}"
      }
      session = FacebookClient::IframeSession.create_and_secure(@fb,params)
      assert_equal '1747108423', session.uid
    end
    
  end
  
end