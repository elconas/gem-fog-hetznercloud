module Fog
  module Hetznercloud
    class Compute
      class Real
        def list_server_types(filters = {})
          get('/server_types', filters)
        end
      end

      class Mock
        def list_server_types
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
