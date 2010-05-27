require File.dirname(__FILE__)+'/../environment'

require 'shoulda'
require 'rr'

class LegacySessionTest < Test::Unit::TestCase
  
  include RR::Adapters::TestUnit
  
  context 'LegacySession' do
    setup do
      @fb = Fb.new(
        :app_id => 123,
        :secret => "3d5b507696ec366sfb8edb96e41eb971"
      )
    end
    should 'accept valid params' do
      params = {
        'fb_sig_user' => '1747108423',
        'fb_sig_locale' => 'en_US',
        'fb_sig_api_key' => '1234lkasjfla',
        'fb_sig' => 'b2dce473bc98eaf6d9e75d296e822ac6'
      }
      session = FacebookClient::LegacySession.create_and_secure(@fb,params)
      assert_equal '1747108423', session.uid
    end
    
  end
  
end