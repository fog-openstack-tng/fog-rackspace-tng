require 'fog/rackspacetng/core'
require 'fog/openstackcommon/common'
require 'fog/openstackcommon/identity'
require 'fog/rackspacetng/services/identity_v1'
require 'fog/rackspacetng/services/identity_v2'

module Fog
  module RackspaceTng
    class Identity
      US_ENDPOINT = 'https://identity.api.rackspacecloud.com/v2.0'
      UK_ENDPOINT = 'https://lon.identity.api.rackspacecloud.com/v2.0'

      def self.new(options, connection_options = {})
        opts = options.dup  # dup options so no wonky side effects
        
        service_discovery = Fog::OpenStackCommon::ServiceDiscovery.new(
          "identity", opts.merge(
            :connection_options => connection_options,
            :base_provider => Fog::RackspaceTng
          )
        )

        service_discovery.call
      end
    end
  end
end
