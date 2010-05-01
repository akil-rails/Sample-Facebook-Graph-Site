class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  include FacebookClient

  protected
    def facebook_session_or_bust
      facebook_session or
      redirect_to '/auth/facebook'
    end

    def facebook_session
      # debugger
      session[:facebook_access_token]
    end

    def access_token
      @access_token ||= facebook_client.web_server.get_access_token(facebook_session, :redirect_uri => facebook_redirect_uri)
    end

end
