# frozen_string_literal: true

module Fullscriptapi
  module Servers
    SERVERS = {
      "dev" => "http://localhost:3000",
      "us_snd" => "https://api-us-snd.fullscript.io",
      "ca_snd" => "https://api-ca-snd.fullscript.io",
      "us_prod" => "https://api-us.fullscript.io",
      "ca_prod" => "https://api-ca.fullscript.io"
    }.freeze

    def get_server
      SERVERS["#{server}"]
    end
  end
end