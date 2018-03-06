module Fog
  module Hetznercloud
    class Compute
      class ServerTypes < Fog::Collection
        model Fog::Hetznercloud::Compute::ServerType

        def all(filters = {})
          server_types = service.list_server_types(filters).body['server_types'] || []
          load(server_types)
        end

        def get(identity)
          if (server_type = service.get_server_type(identity).body['server_type'])
            new(server_type)
          end
        rescue Fog::Hetznercloud::Compute::UnknownResourceError
          nil
        end
      end
    end
  end
end
