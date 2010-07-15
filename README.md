# PROLOGUE

There are a lot of great Facebook API clients out there and most of them are coded better than this one.  Still none worked out for me.  Facebooker was bloated (a class for every api call, yikes!), and others were slow to adopt to platform changes.  This is my personal client and I use it on several high traffic apps (over 1M dau).  The general philosophy is to have a minimal codebase that can adapt to dramatic changes in the Facebook API. 

# CONFIGURATION

This client is tailored for Heroku in that configuration variables are pulled from the environment.

Set the following variables in the appropriate environment file

    ENV['FB_APP_ID']       = "gattaca"
    ENV['FB_API_KEY']      = "gattaca"
    ENV['FB_SECRET']       = "gattaca"
    ENV['FB_CANVAS']       = "gattaca"
    ENV['FB_CALLBACK_URL'] = "http://gattaca.heroku.com" # no trailing slash 

# EXAMPLES

    class Fb < FacebookClient::Base
      # custom methods here
    end
             
    # initialize client with default configuration
    fb = Fb.new
  
    # make a rest api call
    fb.rest_api.call 'admin.setAppProperties', :properties => {
      :application_name   => 'Snowbook',
      :callback_url       => self.callback_url+'/',
      :connect_url        => self.callback_url+'/',
      :iframe_enable_util => 1,
      :use_iframe         => 1,
      :is_mobile          => 1,
      :dev_mode           => 0,
      :privacy_url        => self.callback_url+'/privacy.html'
    }.to_json 
  
    # generate oauth2 authorization url
    fb.auth.url(
      :scope        => User.required_permissions.join(','),
      :redirect_uri => redirect_uri,
      :display      => 'page'
    )
  
    # obtain access_token from oauth2 authorization callback
    graph = fb.auth.request_access(
      :code         => params[:code],
      :redirect_uri => fb.redirect_uri
    )                 
    graph.access_token
  
    # inialization oauth2 session with access token
    graph = Fb.new.graph(user.access_token, 0)
    graph.get('/me')

# Tests

1. Setup `test/config.rb` with your facebook app credentials
2. Open new terminal window and run the sinatra app: `cd test && ruby app.rb`
3. `rake test:units` (or to run individual tests, `ruby test/units/test_name.rb`)