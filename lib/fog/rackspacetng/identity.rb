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
        opts.merge!(
          :connection_options => connection_options,
          :base_provider => Fog::RackspaceTng
        )
        
        service_discovery = Fog::OpenStackCommon::ServiceDiscovery.new("identity", opts)
        service_discovery.call
      end

      private
      
      def osc_options_from(options = {})
        { :openstack_username => options[:rackspace_username],
          :openstack_api_key  => options[:rackspace_api_key],
          :openstack_auth_url => options[:rackspace_auth_url] || US_ENDPOINT,
          :openstack_tenant   => options[:rackspace_username],
          :openstack_region   => options[:rackspace_region] }
      end
    end
  end
end
