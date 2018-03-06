module Fog
  module Hetznercloud
    class Compute
      class FloatingIps < Fog::Collection
        model Fog::Hetznercloud::Compute::FloatingIp

        def all(filters = {})
          floating_ips = service.list_floating_ips(filters).body['floating_ips'] || []
          load(floating_ips)
        end

        def get(identity)
          if (floating_ip = service.get_floating_ip(identity).body['floating_ip'])
            new(floating_ip)
          end
        rescue Fog::Hetznercloud::Compute::UnknownResourceError
          nil
        end
      end
    end
  end
end
