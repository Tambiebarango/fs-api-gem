# frozen_string_literal: true

require_relative 'endpoints/list_all_products'
require_relative 'endpoints/create_an_oauth_token'
require_relative 'endpoints/refresh_token'

module Fullscriptapi
  module Endpoints
    include ListAllProducts
  end
end