module Fog
  module Hetznercloud
    class Compute
      class Real
        def get_server(server_id)
          get("/servers/#{server_id}")
        end
      end

      class Mock
        def get_server(_server_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
