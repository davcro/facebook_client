task :publish do
  version = File.read('VERSION')
  puts "publishing gem facebook_client #{version}"
  exec "gem build facebook_client.gemspec ; gem push facebook_client-#{version}.gem ; rm -f facebook_client-#{version}.gem"
end

task :install do
  version = File.read('VERSION')
  exec "gem build facebook_client.gemspec ; gem install facebook_client-#{version}.gem --no-ri --no-rdoc ; rm -f facebook_client-#{version}.gem"
end

namespace :test do
  
  task :units do
    require 'test/units/base_test.rb'
    require 'test/units/graph_test.rb'
    require 'test/units/auth_test.rb'
    require 'test/units/session/cookie_test.rb'
    require 'test/units/session/fb_sig_param_test.rb'
    require 'test/units/session/signed_request_param_test.rb'
    require 'test/units/session/session_param_test.rb'
  end
  
end
