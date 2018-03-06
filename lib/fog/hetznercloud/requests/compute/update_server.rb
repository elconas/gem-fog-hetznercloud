module Fog
  module Hetznercloud
    class Compute
      class Real
        def update_server(server_id, body)
          update("/servers/#{server_id}", body)
        end
      end

      class Mock
        def update_server(_server_id, _body)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
