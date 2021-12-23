# frozen_string_literal: true

require_relative 'authentication_endpoints/create_an_oauth_token'
require_relative 'authentication_endpoints/refresh_token'

module Fullscriptapi
  module AuthenticationEndpoints
    include CreateAnOauthToken
    include RefreshToken
  end
end