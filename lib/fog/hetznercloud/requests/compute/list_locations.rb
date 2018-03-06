module Fog
  module Hetznercloud
    class Compute
      class Real
        def list_locations(filters = {})
          get('/locations', filters)
        end
      end

      class Mock
        def list_locations
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
