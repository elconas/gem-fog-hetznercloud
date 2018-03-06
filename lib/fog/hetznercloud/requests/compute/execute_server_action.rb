module Fog
  module Hetznercloud
    class Compute
      class Real
        def execute_server_action(id, action, body = {})
          create("/servers/#{id}/actions/#{action}", body)
        end
      end

      class Mock
        def execute_server_action(_id, _action)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
