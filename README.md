# PROLOGUE

There are a lot of great Facebook API clients out there (links below) and most of them are coded better than this one.  Still none worked out for me.  Facebooker was bloated (a class for every api call, yikes!), and others were slow to adopt to platform changes.  This is my personal client and I use it on several high traffic apps (over 1M dau).  The general philosophy is to have a minimal codebase that can adapt to dramatic changes in the Facebook API. 


# CONFIGURATION

This client is tailored for Heroku in that configuration variables are pulled from the environment.

Set the following variables in the appropriate environment file

`
ENV['FB_APP_ID']
ENV['FB_API_KEY']
ENV['FB_SECRET']
ENV['FB_CANVAS']
ENV['FB_CALLBACK_URL']
`


 



