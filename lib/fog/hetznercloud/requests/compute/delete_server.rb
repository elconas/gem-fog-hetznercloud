module Fog
  module Hetznercloud
    class Compute
      class Real
        def delete_server(server_id)
          delete("/servers/#{server_id}")
        end
      end

      class Mock
        def delete_server(server_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
