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
  redirect $fb.graph_authenticator.authorize_url(
    :redirect_uri => redirect_uri,
    :scope        => 'email'
  )
end

get '/fb/auth/callback' do
  access = $fb.graph_authenticator.request_access(
    :redirect_uri => redirect_uri,
    :code         => params[:code]
  )
  user = access.get('/me')
  user.inspect
end

def redirect_uri
  ENV['FB_CALLBACK_URL'] + '/fb/auth/callback'
end