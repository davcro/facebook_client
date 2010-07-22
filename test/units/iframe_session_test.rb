require File.dirname(__FILE__)+'/../environment'

require 'shoulda'
require 'rr'

class IframeSessionTest < Test::Unit::TestCase
  
  include RR::Adapters::TestUnit
  
  context 'IframeSession' do
    setup do
      # sample fb data from july 19, 2010
      # {"fb_sig_app_id"=>"126995317325037", "signed_request"=>"XRVtkDu6T9Kre3nIcQXLlAdD8A8pW09QDxX_S1t1yJQ.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjAsIm9hdXRoX3Rva2VuIjoiMTI2OTk1MzE3MzI1MDM3fGViNmU2ZTczNGFlNjY0ZjMwMWQ4YTM3NS0xMDAwMDExNjU1MDczMTl8QlZxMER4MnVUVXdfTWUwbXkxQzBPLUZYYVNZLiIsInVzZXJfaWQiOiIxMDAwMDExNjU1MDczMTkifQ", "fb_sig_iframe_key"=>"98f13708210194c475687be6106a3b84", "fb_sig_locale"=>"en_US", "fb_sig_in_iframe"=>"1", "action"=>"index", "fb_sig"=>"0f9c16fe38b6507287a513070fc4882e", "fb_sig_in_new_facebook"=>"1", "fb_sig_added"=>"1", "fb_sig_country"=>"us", "fb_sig_ext_perms"=>"read_stream,status_update,photo_upload,video_upload,offline_access,email,create_note,share_item,publish_stream,user_photos,user_photo_video_tags,friends_photos,friends_photo_video_tags", "fb_sig_cookie_sig"=>"07eea766c8bdc363783472c34aea3cba", "fb_sig_session_key"=>"eb6e6e734ae664f301d8a375-100001165507319", "fb_sig_expires"=>"0", "fb_sig_ss"=>"cde1e8478e3f7d72960da3133091d6ae", "controller"=>"quizzes", "fb_sig_api_key"=>"12ad2dc78d9f6816ae50be94f93b571c", "fb_sig_user"=>"100001165507319", "fb_sig_profile_update_time"=>"1275440106", "fb_sig_time"=>"1279687778.633"}
      @fb = Fb.new(
        :app_id => 123
      )
      @signed_request = "XRVtkDu6T9Kre3nIcQXLlAdD8A8pW09QDxX_S1t1yJQ.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjAsIm9hdXRoX3Rva2VuIjoiMTI2OTk1MzE3MzI1MDM3fGViNmU2ZTczNGFlNjY0ZjMwMWQ4YTM3NS0xMDAwMDExNjU1MDczMTl8QlZxMER4MnVUVXdfTWUwbXkxQzBPLUZYYVNZLiIsInVzZXJfaWQiOiIxMDAwMDExNjU1MDczMTkifQ"
      @params = {
        "signed_request" => @signed_request
      }
      @session = FacebookClient::IframeSession.create_and_secure(@fb, @params)
    end
    
    should "verify signed request" do
      assert FacebookClient::IframeSession.verify_signed_request(@fb.secret, @params["signed_request"])
      assert_equal ENV["FB_USER_ID"], FacebookClient::IframeSession.parse_params(@params["signed_request"])["user_id"]
    end
    
    should 'accept valid params' do
      @session = FacebookClient::IframeSession.create_and_secure(@fb, @params)
      assert_equal ENV["FB_USER_ID"], @session.uid
    end
    
    should "create a valid Graph instance with an access token" do
      graph = @session.graph
      assert_not_nil graph
      assert_equal ENV['FB_OAUTH_TOKEN_SAMPLE'], graph.access_token
    end
  end
  
end