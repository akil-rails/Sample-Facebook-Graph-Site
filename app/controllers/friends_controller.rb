class FriendsController < ApplicationController
  before_filter :facebook_session_or_bust
  def index
    @friends = JSON.parse(access_token.get('/me/friends'))
  end
end
