# http://developers.facebook.com/docs/authentication/canvas
# sample fb data from july 19, 2010
# {"fb_sig_app_id"=>"126995317325037", "signed_request"=>"XRVtkDu6T9Kre3nIcQXLlAdD8A8pW09QDxX_S1t1yJQ.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjAsIm9hdXRoX3Rva2VuIjoiMTI2OTk1MzE3MzI1MDM3fGViNmU2ZTczNGFlNjY0ZjMwMWQ4YTM3NS0xMDAwMDExNjU1MDczMTl8QlZxMER4MnVUVXdfTWUwbXkxQzBPLUZYYVNZLiIsInVzZXJfaWQiOiIxMDAwMDExNjU1MDczMTkifQ", "fb_sig_iframe_key"=>"98f13708210194c475687be6106a3b84", "fb_sig_locale"=>"en_US", "fb_sig_in_iframe"=>"1", "action"=>"index", "fb_sig"=>"0f9c16fe38b6507287a513070fc4882e", "fb_sig_in_new_facebook"=>"1", "fb_sig_added"=>"1", "fb_sig_country"=>"us", "fb_sig_ext_perms"=>"read_stream,status_update,photo_upload,video_upload,offline_access,email,create_note,share_item,publish_stream,user_photos,user_photo_video_tags,friends_photos,friends_photo_video_tags", "fb_sig_cookie_sig"=>"07eea766c8bdc363783472c34aea3cba", "fb_sig_session_key"=>"eb6e6e734ae664f301d8a375-100001165507319", "fb_sig_expires"=>"0", "fb_sig_ss"=>"cde1e8478e3f7d72960da3133091d6ae", "controller"=>"quizzes", "fb_sig_api_key"=>"12ad2dc78d9f6816ae50be94f93b571c", "fb_sig_user"=>"100001165507319", "fb_sig_profile_update_time"=>"1275440106", "fb_sig_time"=>"1279687778.633"}
# The signed_request parameter is the concatenation of
# a HMAC SHA-256 signature string, a period (.),
# and a base64url encoded JSON object.
# It looks something like this (without the newlines):
# vlXgu64BQGFSQrY0ZcJBZASMvYvTHu9GQ0YM9rjPSso
# .
# eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsIjAiOiJwYXlsb2FkIn0
module FacebookClient

  module Session

    require 'digest'
    require 'digest/md5'
    require 'yajl' 
    require 'base64'
    require 'openssl'

    class SignedRequestParam < Base

      def self.create_and_secure(fb, params)
        session = new(fb, params)
  
        session.secure? ? session : nil
      end

      def initialize(fb, params)
        @fb=fb
        @data=parse_signed_request!(params["signed_request"])
      end

      def parse_signed_request!(str)
        @data = str &&
          check_sig_and_return_data(str, self.class.parse_params(str))
      end

      def secure?
        @data.is_a?(Hash) and @data.has_key?('user_id')
      end
    
      def uid
        @data['user_id']
      end
      
      def access_token
        @data["oauth_token"]
      end

      # private

      def check_sig_and_return_data(signed_request, params)
        params if self.class.verify_signed_request(@fb.secret, signed_request)
      end

      def calculate_sig(params)
        args = params.reject{ |(k, v)| k == 'sig' }.sort.
          map{ |a| a.join('=') }.join

        Digest::MD5.hexdigest(args + @fb.secret)
      end
  
      # looks like this:
      # {"expires"=>0, "algorithm"=>"HMAC-SHA256", "user_id"=>"19392189382", "oauth_token"=>"some-token"}
      def self.parse_params(signed_request)
        encoded_url = signed_request.split(".").last
        data = JSON.parse(base64_url_decode(encoded_url))
      end
  
      # This function takes the app secret and the signed request, and verifies if the request is valid.
      def self.verify_signed_request(secret, signed_request)
        signature, encoded_url = signed_request.split(".")
        signature = base64_url_decode(signature)
        expected_sig = OpenSSL::HMAC.digest('SHA256', secret, encoded_url.tr("-_", "+/"))
        return signature == expected_sig
      end
  
      # Ruby's implementation of base64 decoding seems to be reading the string in multiples of 4 and ignoring
      # any extra characters if there are no white-space characters at the end. Since facebook does not take this
      # into account, this function fills any string with white spaces up to the point where it becomes divisible
      # by 4, then it replaces '-' with '+' and '_' with '/' (URL-safe decoding), and decodes the result.
      def self.base64_url_decode(str)
        str = str + "=" * (4 - str.size % 4) unless str.size % 4 == 0
        return Base64.decode64(str.tr("-_", "+/"))
      end

    end
    
  end
end