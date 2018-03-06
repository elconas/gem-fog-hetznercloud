module Fog
  module Hetznercloud
    class Compute
      class Real
        def floating_ip_unassign(id, body)
          create("/floating_ips/#{id}/actions/unassign", body)
        end
      end

      class Mock
        def floating_ip_unassign(type, body)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
