module Fog
  module Hetznercloud
    class Compute
      class Locations < Fog::Collection
        model Fog::Hetznercloud::Compute::Location

        def all(filters = {})
          locations = service.list_locations(filters).body['locations'] || []
          load(locations)
        end

        def get(identity)
          if (location = service.get_location(identity).body['location'])
            new(location)
          end
        rescue Fog::Hetznercloud::Compute::UnknownResourceError
          nil
        end
      end
    end
  end
end
