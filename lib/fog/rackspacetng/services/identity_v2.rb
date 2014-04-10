require 'fog/openstackcommon/services/identity_v2'

module Fog
  module RackspaceTng
    class IdentityV2 < Fog::OpenStackCommon::IdentityV2
      requires   :rackspace_username
      requires   :rackspace_api_key
      requires   :rackspace_region
      recognizes :rackspace_auth_url

      class Real < Fog::OpenStackCommon::IdentityV2::Real
        def initialize(options = {})
          @rax_options = options.dup
          
          options[:openstack_auth_url] = options.delete(:rackspace_auth_url) || 
            Fog::RackspaceTng::Identity::US_ENDPOINT
          options[:openstack_username] = options.delete(:rackspace_username)
          options[:openstack_api_key]  = options.delete(:rackspace_api_key)
          
          super options
        end

        def request_params(params)
          super.merge({
            :path     => "v2.0/#{params[:path]}"
          })
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


        def create_token(username, api_key)
          binding.pry
          data = {
            'auth' => {
              'RAX-KSKEY:apiKeyCredentials' => {
                'username' => username,
                'apiKey' => api_key
              }
            }
          }

          request_without_retry(
            :body => Fog::JSON.encode(data),
            :expects => [200, 203],
            :method => 'POST',
            :path => 'tokens'
          )
        end
      end
    end
  end
end
