module Fog
  module Hetznercloud
    class Compute
      class Real
        def delete_image(id)
          delete("/images/#{id}")
        end
      end

      class Mock
        def delete_image(id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
