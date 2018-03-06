module Fog
  module Hetznercloud
    class Compute
      class Real
        def get_floating_ip(id)
          get("/floating_ips/#{id}")
        end
      end

      class Mock
        def get_floating_ip(_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
