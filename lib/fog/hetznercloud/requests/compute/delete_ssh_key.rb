module Fog
  module Hetznercloud
    class Compute
      class Real
        def delete_ssh_key(id)
          delete("/ssh_keys/#{id}")
        end
      end

      class Mock
        def delete_ssh_key(id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
