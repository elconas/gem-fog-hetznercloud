module Fog
  module Hetznercloud
    class Compute
      class Real
        def get_ssh_key(id)
          get("/ssh_keys/#{id}")
        end
      end

      class Mock
        def get_ssh_key(id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
