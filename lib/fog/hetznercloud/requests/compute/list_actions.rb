module Fog
  module Hetznercloud
    class Compute
      class Real
        def list_ssh_keys(filters = {})
          get('/ssh_keys', filters)
        end
      end

      class Mock
        def list_ssh_keys
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
