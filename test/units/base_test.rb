require File.dirname(__FILE__)+'/../environment'
require 'shoulda'

class BaseTest < Test::Unit::TestCase
  
  context 'facebook client base' do
    setup do
      @fb = Fb.new
    end
    
    should 'have dynamic params' do
      assert_equal ENV['FB_SECRET'], @fb.secret
    end
    
  end
  
end