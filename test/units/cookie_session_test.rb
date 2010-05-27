require File.dirname(__FILE__)+'/../environment'

require 'shoulda'
require 'rr'

class CookieSessionTest < Test::Unit::TestCase
  
  include RR::Adapters::TestUnit
  
  context 'CookieSession' do

    should 'accept valid cookies' do
      fb = Fb.new(
        :app_id => 104605292906070,
        :secret => "3d5b507696ec366adb8edb96e41eb971"
      )
      cookies = {
        "fbs_104605292906070"=>"\"access_token=104605292906070|2.bPFJzDq46n_zSpb6TMALZw__.3600.1272099600-1747108323|7z-vaKhqjKzO5sZdaSCM0rzAPwI.&expires=1272099600&secret=bPFJzDq46n_zSpb6TMALZw__&session_key=2.bPFJzDq46n_zSpb6TMALZw__.3600.1272099600-1747108323&sig=eac661d93156db2d5333cc6717ca2938&uid=1747108323\""
      }
      session = FacebookClient::CookieSession.create_and_secure(fb, cookies)
      assert_not_nil session
    end
    
  end
  
end