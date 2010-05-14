require File.dirname(__FILE__)+'/../environment'
require 'shoulda'
require 'rr'

class GraphAccessTest < Test::Unit::TestCase
  
  include RR::Adapters::TestUnit
  
  context 'graph access' do
    setup do
      @access_token = '2.mqSf8VbjxcdKaZP54tucrw__.3600.1273809600-1747108323|YwW6tqsjhzXHV_SjP-UNHessE4U.'
      @fb = Fb.new
      @access = @fb.graph_access(@access_token)
    end
    
    should 'GET' do
      assert true
    end
    
  end
  
end