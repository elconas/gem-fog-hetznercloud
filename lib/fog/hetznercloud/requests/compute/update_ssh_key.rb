module Fog
  module Hetznercloud
    class Compute
      class Real
        def update_ssh_key(id, body)
          update("/ssh_keys/#{id}", body)
        end
      end

      class Mock
        def update_ssh_key(server_id, body)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
