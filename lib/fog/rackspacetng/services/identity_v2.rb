require 'fog/openstackcommon/services/identity_v2'

module Fog
  module RackspaceTng
    class IdentityV2 < Fog::OpenStackCommon::IdentityV2
      requires   :rackspace_username
      requires   :rackspace_api_key
      requires   :rackspace_region
      recognizes :rackspace_auth_url

      request_path 'fog/rackspacetng/requests/identity/v2'
      request :create_token

      class Real < Fog::OpenStackCommon::IdentityV2::Real
        def initialize(options = {})
          @rax_options = options.dup
          
          options[:openstack_auth_url] = options.delete(:rackspace_auth_url) || 
            Fog::RackspaceTng::Identity::US_ENDPOINT
          options[:openstack_username] = options.delete(:rackspace_username)
          options[:openstack_api_key]  = options.delete(:rackspace_api_key)
          
          super options
        end

        def request_without_retry(params, parse_json = true)
          response = @service.request(request_params(params))

          process_response(response) if parse_json
          response
        end

        def process_response(response)
          if response &&
              response.body &&
              response.body.is_a?(String) &&
              !response.body.strip.empty? &&
              Fog::RackspaceTng.json_response?(response)
            begin
              response.body = Fog::JSON.decode(response.body)
            rescue Fog::JSON::DecodeError => e
              Fog::Logger.warning("Error Parsing response json - #{e}")
              response.body = {}
            end
          end
        end
      end
    end
  end
end
