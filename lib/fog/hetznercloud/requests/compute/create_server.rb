module Fog
  module Hetznercloud
    class Compute
      class Real
        def create_server(name, image, server_type, options = {})
          body = {
            name: name,
            image: image,
            server_type: server_type
          }

          # if !@datacenter.nil?
          #   body.merge!({datacenter:  @datacenter})
          # elsif !@location.nil?
          #   body.merge!({location:  @location})
          # end

          body.merge!(options)

          create('/servers', body)
        end
      end

      class Mock
        def create_server(_name, _image, _volumes, _options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
