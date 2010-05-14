require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__)+'/environment'

configure do
  $fb = Fb.new
end

get '/' do
  'hello world!'
end

get '/fb/auth' do
  redirect $fb.auth.url(
    :redirect_uri => redirect_uri,
    :scope        => 'email'
  )
end

get '/fb/auth/callback' do
  access = $fb.auth.request_access(
    :redirect_uri => redirect_uri,
    :code         => params[:code]
  )
  user = access.get('/me')
  user.inspect
end

def redirect_uri
  ENV['FB_CALLBACK_URL'] + '/fb/auth/callback'
end