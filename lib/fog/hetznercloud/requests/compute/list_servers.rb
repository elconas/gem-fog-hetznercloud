module Fog
  module Hetznercloud
    class Compute
      class Real
        def list_servers(filters = {})
          get('/servers', filters)
        end
      end

      class Mock
        def list_servers
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
