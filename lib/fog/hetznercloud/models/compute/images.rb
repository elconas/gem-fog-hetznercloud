module Fog
  module Hetznercloud
    class Compute
      class Images < Fog::Collection
        model Fog::Hetznercloud::Compute::Image

        def all(filters = {})
          images = service.list_images(filters).body['images'] || []
          load(images)
        end

        def get(identity)
          if (image = service.get_image(identity).body['image'])
            new(image)
          end
        rescue Fog::Hetznercloud::Compute::UnknownResourceError
          nil
        end
      end
    end
  end
end
