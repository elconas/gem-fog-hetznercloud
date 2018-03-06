module Fog
  module Hetznercloud
    class Compute
      class Real
        def floating_ip_update_dns_ptr(id, body)
          create("/floating_ips/#{id}/actions/change_dns_ptr", body)
        end
      end

      class Mock
        def floating_ip_update_dns_ptr(type, body)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
