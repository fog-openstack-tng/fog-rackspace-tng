require 'multi_json'
require 'fog/core'
require 'fog/json'

module Fog
  module RackspaceTng
    extend Fog::Provider

    service(:identity,      'Identity')

    def self.authenticate(options, connection_options = {})
      Fog::Identity.new(options, connection_options = {})
    end

    def self.json_response?(response)
      return false unless response && response.headers
      response.get_header('Content-Type') =~ %r{application/json}i ? true : false
    end
  end
end
