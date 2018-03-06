module Fog
  module Hetznercloud
    class Compute
      class Real
        def update_ssh_key(id, body)
          update("/ssh_keys/#{id}", body)
        end
      end

      class Mock
        def update_ssh_key(_server_id, _body)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
