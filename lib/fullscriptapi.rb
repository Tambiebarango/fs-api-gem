require_relative "fullscriptapi/version"
require 'excon'

module FullscriptApi
  class << self
    attr_accessor :client_id, :secret, :redirect_uri, :token, :server
    
    def config
      yield self if block_given?

      self
    end
    alias :new :config

    def use_token(token)
      @token = token
    end

    def list_all_products
      response = Excon.get("#{server}/api/catalog/products",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer #{@token}"
        }
      )

      response
    end
  end
end
