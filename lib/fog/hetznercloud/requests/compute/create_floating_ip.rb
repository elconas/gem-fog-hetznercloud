module Fog
  module Hetznercloud
    class Compute
      class Real
        def create_floating_ip(type, options = {})
          body = {
            type: type
          }

          # if !@datacenter.nil?
          #   body.merge!({datacenter:  @datacenter})
          # elsif !@location.nil?
          #   body.merge!({location:  @location})
          # end

          body.merge!(options)

          create('/floating_ips', body)
        end
      end

      class Mock
        def create_floating_ip(_type, _options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
