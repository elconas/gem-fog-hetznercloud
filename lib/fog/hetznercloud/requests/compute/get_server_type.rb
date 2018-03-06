module Fog
  module Hetznercloud
    class Compute
      class Real
        def get_server_type(server_type_id)
          get("/server_types/#{server_type_id}")
        end
      end

      class Mock
        def get_server_type(server_type_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
