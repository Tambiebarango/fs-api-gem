# frozen_string_literal: true

module Fullscriptapi
  module AuthenticationEndpoints
    module RefreshToken
      def refresh_token
        response = Excon.post("#{get_server}/api/oauth/token",
          headers: {
            "Content-Type": "application/json"
          },
          body: {
            grant_type: "refresh_token",
            client_id: client_id,
            client_secret: secret,
            redirect_uri: redirect_uri,
            refresh_token: token.refresh_token
          }.to_json
        )
  
        body = JSON.parse(response.body)
  
        use_token(body["oauth"])
      end
    end
  end
end