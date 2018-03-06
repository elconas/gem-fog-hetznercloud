module Fog
  module Hetznercloud
    class Compute
      class Real
        def get_location(id)
          get("/locations/#{id}")
        end
      end

      class Mock
        def get_location(_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
