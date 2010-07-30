module FacebookClient
  
  module Session
    
    class Base
      
      attr_reader :fb

      def graph
        @graph ||= Graph.new(fb, access_token, 0)
      end
      
    end
    
  end
  
end