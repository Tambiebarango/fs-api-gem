# frozen_string_literal: true

module Fullscriptapi
  module Endpoints
    module ListAllProducts
      def list_all_products
        refresh_token if stale_token? #to do: add logic to conditionally refresh token
  
        Excon.get("#{get_server}/catalog/products",
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer #{token.access_token}"
          }
        )
      end
    end
  end
end