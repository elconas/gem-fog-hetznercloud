module Fog
  module Hetznercloud
    class Compute
      class Real
        def list_datacenters(filters = {})
          get('/datacenters', filters)
        end
      end

      class Mock
        def list_datacenters
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
