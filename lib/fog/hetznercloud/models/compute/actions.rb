module Fog
  module Hetznercloud
    class Compute
      class Actions < Fog::Collection
        model Fog::Hetznercloud::Compute::Action

        def all(filters = {})
          actions = service.list_actions(filters).body['actions'] || []
          load(actions)
        end

        def get(identity)
          if (action = service.get_action(identity).body['action'])
            new(action)
          end
        rescue Fog::Hetznercloud::Compute::UnknownResourceError
          nil
        end
      end
    end
  end
end
