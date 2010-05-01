# Allow the metal piece to run in isolation
require File.expand_path('../../../config/environment',  __FILE__) unless defined?(Rails)

class FacebookOauth < Sinatra::Base

  def client
    @client = OAuth2::Client.new(FACEBOOK_CONF[:api_key], FACEBOOK_CONF[:api_secret], :site => 'https://graph.facebook.com')
    # Makes a request relative to the specified site root.
    def @client.request(verb, url, params = {}, headers = {})
      puts "#{verb}: #{url} with \n#{params.inspect}"
      if verb == :get
        resp = connection.run_request(verb, url, nil, headers) do |req|
          req.params.update(params)
        end
      else
        resp = connection.run_request(verb, url, params, headers)
      end
      case resp.status
        when 200...201 then ResponseString.new(resp)
        when 401
          e = OAuth2::AccessDenied.new("Received HTTP 401 during request.")
          e.response = resp
          raise e
        else
          e = OAuth2::HTTPError.new("Received HTTP #{resp.status} during request.")
          e.response = resp
          raise e
      end
    end
    @client
  end

  get '/auth/facebook' do
    redirect client.web_server.authorize_url(
      :redirect_uri => redirect_uri,
      :scope => 'email,offline_access'
    )
  end

  get '/auth/facebook/callback' do
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
    user = JSON.parse(access_token.get('/me'))

    # session[:facebook_id] = user['id']
    # request.cookies[:facebook_id] = user
    # request.cookies
    # response.set_cookie('facebook_access_token', {:value => params[:code], :path => '/'})
    session = env['rack.session']
    session[:facebook_access_token] = params[:code]
    "<html><body>#{user.inspect}</body></html>"
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/auth/facebook/callback'
    uri.query = nil
    uri.to_s
  end

end