module Fog
  module Hetznercloud
    class Compute
      class Real
        def get_image(image_id)
          get("/images/#{image_id}")
        end
      end

      class Mock
        def get_image(image_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
