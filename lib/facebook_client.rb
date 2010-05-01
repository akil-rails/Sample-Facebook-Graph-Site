module FacebookClient
  def facebook_client
    @facebook_client = OAuth2::Client.new(FACEBOOK_CONF[:api_key], FACEBOOK_CONF[:api_secret], :site => 'https://graph.facebook.com')
    # Makes a request relative to the specified site root.
    def @facebook_client.request(verb, url, params = {}, headers = {})
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
    @facebook_client
  end

  def facebook_redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/auth/facebook/callback'
    uri.query = nil
    uri.to_s
  end

end