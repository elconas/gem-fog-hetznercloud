module Fog
  module Hetznercloud
    class Compute
      class Real
        def floating_ip_assign_to_server(id, body)
          create("/floating_ips/#{id}/actions/assign", body)
        end
      end

      class Mock
        def floating_ip_assign_to_server(type, body)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
