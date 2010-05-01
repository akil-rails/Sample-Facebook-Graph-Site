# Allow the metal piece to run in isolation
require File.expand_path('../../../config/environment',  __FILE__) unless defined?(Rails)

class FacebookOauth < Sinatra::Base
  include FacebookClient

  get '/auth/facebook' do
    redirect facebook_client.web_server.authorize_url(
      :redirect_uri => facebook_redirect_uri,
      :scope => 'email,offline_access'
    )
  end

  get '/auth/facebook/callback' do
    access_token = facebook_client.web_server.get_access_token(params[:code], :redirect_uri => facebook_redirect_uri)
    user = JSON.parse(access_token.get('/me'))

    session = env['rack.session']
    session[:facebook_access_token] = params[:code]
    redirect '/'
  end

end