module Fog
  module Hetznercloud
    class Compute
      class Real
        def update_floating_ip(id, body)
          update("/floating_ips/#{id}", body)
        end
      end

      class Mock
        def update_floating_ip(id, body)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
