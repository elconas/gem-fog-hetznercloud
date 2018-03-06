module Fog
  module Hetznercloud
    class Compute
      class Real
        def update_image(id, body)
          update("/images/#{id}", body)
        end
      end

      class Mock
        def update_image(_server_id, _body)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
