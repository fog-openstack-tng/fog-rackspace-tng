module Fog
  module RackspaceTng
    class IdentityV2
      class Real
        def create_token(username, api_key, _)
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
            :path => 'v2.0/tokens'
          )
        end
      end
    end
  end
end
