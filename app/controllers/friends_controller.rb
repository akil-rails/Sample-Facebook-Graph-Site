class FriendsController < ApplicationController
  before_filter :facebook_session_or_bust
  def index
    @friends = facebook_data('me','friends')
  end
  def show
    @friend = facebook_data(params[:id])
    @photos = facebook_data(params[:id], "photos")
    @albums = facebook_data(params[:id], 'albums')
  end

  protected
    def facebook_data(id = 'me', connection = '')
      JSON.parse(access_token.get("/#{id}/#{connection}".sub(/\/\Z/,'')))
    end
end
