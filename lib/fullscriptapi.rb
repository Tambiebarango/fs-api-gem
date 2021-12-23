require_relative "fullscriptapi/version"
require_relative "fullscriptapi/access_token"
require_relative "fullscriptapi/authentication_endpoints"
require 'excon'
require 'json'

module Fullscriptapi
  class << self
    include Fullscriptapi::AuthenticationEndpoints

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

    def method_missing(name, *args, &block)
      super unless api_methods.include?(name.to_s)

      refresh_token if stale_token? # TO-DO: write logic to improve token refresh

      params = excon_params(name, *args)
      
      Excon.send(*params)
    end

    private      
      def get_server
        servers["#{server}"]
      end

      def servers
        {
          "dev" => "http://localhost:3000",
          "us_snd" => "https://api-us-snd.fullscript.io",
          "ca_snd" => "https://api-ca-snd.fullscript.io",
          "us_prod" => "https://api-us.fullscript.io",
          "ca_prod" => "https://api-ca.fullscript.io"
        }
      end

      def stale_token?
        token && token.expired?
      end

      def openapi_json
        @_openapi_json ||=
        JSON.parse(File.read(File.join(File.dirname(__FILE__), '../openapi.json')))["paths"]
      end

      def paths
        openapi_json.keys
      end

      def api_methods
        @_api_methods ||= begin
          available_methods = []
          openapi_json.each do |key, value|
            http_methods = value.keys

            http_methods.each do |method|
              available_methods << value[method.to_s]["summary"].downcase.gsub(" ", "_")
            end
          end
          available_methods
        end
      end

      def excon_params(name, *args)
        path = ""
        method = ""
        args_hash = args.first

        openapi_json.each do |k, v|
          http_methods = v.keys

          http_methods.each do |m|
            v[m.to_s].values.each do |val|
              if val.is_a?(String) && val.downcase.gsub(" ", "_") == name.to_s
                path = k
                method = m
                break
              end
            end
          end
          break unless path.empty?
        end

        first_bracket = path.index('{')
        second_bracket = path.index('}')

        path_dup = path.dup
        path_dup[first_bracket..second_bracket] = args_hash[:id] if args_hash.is_a?(Hash) && args_hash[:id] && first_bracket && second_bracket

        url = "#{get_server}#{path_dup}"

        params = {
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer #{token.access_token}"
          }
        }

        params.merge!(body: args_hash[:body].to_json) if args_hash.is_a?(Hash) && args_hash[:body] && args_hash[:body].is_a?(Hash)

        return method.to_sym, url, params
      end
  end
end
