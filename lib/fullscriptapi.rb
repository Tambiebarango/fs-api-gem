require_relative "fullscriptapi/version"
require_relative "fullscriptapi/access_token"
require_relative "fullscriptapi/authentication_endpoints"
require_relative "fullscriptapi/servers.rb"
require 'excon'
require 'json'

module Fullscriptapi
  class << self
    include Fullscriptapi::AuthenticationEndpoints
    include Fullscriptapi::Servers

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
      @requested_method_hash = api_json_meta.detect { |v| v[:api_method] == name.to_s }
      
      super unless requested_method_hash

      refresh_token if stale_token? # TO-DO: write logic to improve token refresh

      params = excon_params(*args)
      
      Excon.send(*params)
    end

    private
      attr_reader :requested_method_hash

      def stale_token?
        token && token.expired?
      end

      def openapi_json
        @_openapi_json ||=
        JSON.parse(File.read(File.join(File.dirname(__FILE__), '../openapi.json')))["paths"]
      end

      def api_json_meta
        @_api_json_meta ||= begin
          available_methods = []
          openapi_json.each do |key, value|
            http_methods = value.keys

            http_methods.each do |method|
              api_method = value[method.to_s]["summary"].downcase.gsub(" ", "_")
              hash_to_add = {
                api_method: api_method,
                http_method: method,
                path: key
              }
              available_methods << hash_to_add # [ { api_method: "create_a_patient, http_method: "post", path: "api/clinic/patients" }, ... ]
            end
          end
          available_methods
        end
      end

      def excon_params(*args)
        path, http_method, api_method = requested_method_hash.values_at(:path, :http_method, :api_method)
        args_hash = args.first
        first_bracket = path.index('{')
        second_bracket = path.index('}')

        path_dup = path.dup
        if args_hash.is_a?(Hash) && args_hash[:query]
          path_dup[first_bracket..second_bracket] = args_hash[:query][:id] if args_hash[:query][:id] && first_bracket && second_bracket
          path_dup += "?query=#{args_hash[:query][:search]}" if args_hash[:query][:search]
        end

        url = "#{get_server}#{path_dup}"

        params = {
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer #{token.access_token}"
          }
        }

        params.merge!(body: args_hash[:body].to_json) if args_hash.is_a?(Hash) && args_hash[:body] && args_hash[:body].is_a?(Hash)

        return http_method.to_sym, url, params
      end
  end
end
