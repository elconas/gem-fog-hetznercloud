module Fog
  module Hetznercloud
    class Compute
      class Real
        def list_floating_ips(filters = {})
          get('/floating_ips', filters)
        end
      end

      class Mock
        def list_floating_ips
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
