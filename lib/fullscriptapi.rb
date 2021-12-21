require_relative "fullscriptapi/version"
require 'excon'
require 'json'

module FullscriptApi
  class << self
    attr_accessor :client_id, :secret, :redirect_uri, :token, :server

    def config
      yield self if block_given?

      # TO-DO: add validation for redirect_uri

      self
    end
    alias :new :config

    def use_token(token, refresh)
      @token = token
      @refresh = refresh
    end

    def refresh_token
      response = Excon.post("#{get_server}/oauth/token",
        headers: {
          "Content-Type": "application/json"
        },
        body: {
          grant_type: "refresh_token",
          client_id: client_id,
          client_secret: secret,
          redirect_uri: redirect_uri,
          refresh_token: refresh
        }.to_json
      )

      body = JSON.parse(response.body)

      use_token(body["access_token"], body["refresh_token"])
    end

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

      use_token(body["access_token"], body["refresh_token"])

      body
    end

    def list_all_products
      refresh_token #to do: add logic to conditionally refresh token
      response = Excon.get("#{get_server}/catalog/products",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer #{@token}"
        }
      )

      response
    end

    private
      attr_reader :refresh_token
      
      def get_server
        servers["#{server}"]
      end

      def servers
        {
          "dev" => "http://localhost:3000/api",
          "us_snd" => "https://api-us-snd.fullscript.io/api/",
          "ca_snd" => "https://api-ca-snd.fullscript.io/api/",
          "us_prod" => "https://api-us.fullscript.io/api/",
          "ca_prod" => "https://api-ca.fullscript.io/api/"
        }
      end
  end
end
