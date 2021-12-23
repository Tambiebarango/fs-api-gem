# frozen_string_literal: true

module Fullscriptapi
  class AccessToken
    attr_reader :client, :access_token, :expires_in, :expires_at
    attr_accessor :refresh_token

    def initialize(opts = {})
      opts = opts.dup

      %i[access_token refresh_token expires_in expires_at expires_latency].each do |arg|
        instance_variable_set("@#{arg}", opts.delete(arg) || opts.delete(arg.to_s))
      end

      @expires_in ||= opts.delete('expires')
      @expires_in &&= @expires_in.to_i
      @expires_at &&= convert_expires_at(@expires_at)
      @expires_at ||= Time.now.to_i + @expires_in if @expires_in
    end

    def expired?
      expires_at <= Time.now.to_i
    end

    private
      def convert_expires_at(expires_at)
        Time.iso8601(expires_at.to_s).to_i
      rescue ArgumentError
        expires_at.to_i
      end
  end
end
