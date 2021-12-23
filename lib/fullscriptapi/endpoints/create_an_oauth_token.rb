# frozen_string_literal: true

module Fullscriptapi
  module Endpoints
    module CreateAnOauthToken
      def create_an_oauth_token(grant)
        # you need to have an auth grant to use this method
  
        raise unless client_id && secret && redirect_uri
  
        response = Excon.post("#{get_server}/oauth/token",
          headers: {
            "Content-Type": "application/json"
          },
          body: {
            grant_type: "authorization_code",
            client_id: client_id,
            client_secret: secret,
            code: grant,
            redirect_uri: redirect_uri
          }.to_json
        )
  
        body = JSON.parse(response.body)
  
        use_token(body["oauth"])
  
        body
      end
    end
  end
end