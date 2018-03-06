module Fog
  module Hetznercloud
    class Compute
      class Real
        def get_action(id)
          get("/actions/#{id}")
        end
      end

      class Mock
        def get_action(_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
