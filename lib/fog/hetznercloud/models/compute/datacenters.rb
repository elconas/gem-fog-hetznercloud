module Fog
  module Hetznercloud
    class Compute
      class Datacenters < Fog::Collection
        model Fog::Hetznercloud::Compute::Datacenter

        def all(filters = {})
          datacenters = service.list_datacenters(filters).body['datacenters'] || []
          load(datacenters)
        end

        def get(identity)
          if (datacenter = service.get_datacenter(identity).body['datacenter'])
            new(datacenter)
          end
        rescue Fog::Hetznercloud::Compute::UnknownResourceError
          nil
        end
      end
    end
  end
end
