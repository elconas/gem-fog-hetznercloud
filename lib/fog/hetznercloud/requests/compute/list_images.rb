module Fog
  module Hetznercloud
    class Compute
      class Real
        def list_images(filters = {})
          get('/images', filters)
        end
      end

      class Mock
        def list_images
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
