module Fog
  module Hetznercloud
    class Compute
      class Real
        def delete_floating_ip(id)
          delete("/floating_ips/#{id}")
        end
      end

      class Mock
        def delete_floating_ip(id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
