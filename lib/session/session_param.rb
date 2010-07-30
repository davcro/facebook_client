module FacebookClient

  module Session

    require 'digest'
    require 'yajl' 

    class SessionParam

      def self.create_and_secure(fb, params)
        iframe_session = new(fb, params)

        iframe_session.secure? ? iframe_session : nil
      end

      def initialize(fb, params)
        @fb=fb
        @data=parse_fbs!(params["session"])
      end

      def parse_fbs!(fbs)
        @data = fbs &&
          check_sig_and_return_data(Yajl::Parser.parse(fbs))
      end

      def secure?
        @data.is_a?(Hash) and @data.has_key?('uid')
      end

      def graph
        @graph ||= Graph.new(@fb, @data["access_token"], 0)
        @graph
      end

      def uid
        @data['uid']
      end

      # private

      def check_sig_and_return_data(params)
        params if calculate_sig(params) == params['sig']
      end

      def calculate_sig(params)
        args = params.reject{ |(k, v)| k == 'sig' }.sort.
          map{ |a| a.join('=') }.join

        Digest::MD5.hexdigest(args + @fb.secret)
      end

    end
    
  end
end