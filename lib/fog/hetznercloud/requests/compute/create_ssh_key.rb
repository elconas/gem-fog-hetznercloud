module Fog
  module Hetznercloud
    class Compute
      class Real
        def create_ssh_key(name, public_key, options = {})
          body = {
            name: name,
            public_key: public_key,
          }

          body.merge!(options)

          create('/ssh_keys', body)
        end
      end

      class Mock
        def create_ssh_key(type, home_location, server, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
