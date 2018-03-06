module Fog
  module Hetznercloud
    class Compute
      class Real
        def get_datacenter(id)
          get("/datacenters/#{id}")
        end
      end

      class Mock
        def get_datacenter(_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
