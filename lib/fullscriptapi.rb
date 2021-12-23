require_relative "fullscriptapi/version"
require_relative "fullscriptapi/access_token"
require_relative "fullscriptapi/endpoints"
require 'excon'
require 'json'

module Fullscriptapi
  class << self
    include Fullscriptapi::Endpoints

    attr_accessor :client_id, :secret, :redirect_uri, :token, :server

    def config
      yield self if block_given?

      self
    end
    alias :new :config

    def use_token(opts = {})
      # pass in a hash containing token attributes e.g. access_token, refresh_token, expires_*
      @token = Fullscriptapi::AccessToken.new(opts)
    end

    private      
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

      def stale_token?
        token && token.expired?
      end
  end
end
