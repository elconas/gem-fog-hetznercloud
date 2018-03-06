module Fog
  module Hetznercloud
    class Compute
      class SshKeys < Fog::Collection
        model Fog::Hetznercloud::Compute::SshKey

        def all(filters = {})
          ssh_keys = service.list_ssh_keys(filters).body['ssh_keys'] || []
          load(ssh_keys)
        end

        def get(identity)
          if (ssh_key = service.get_ssh_key(identity).body['ssh_key'])
            new(ssh_key)
          end
        rescue Fog::Hetznercloud::Compute::UnknownResourceError
          nil
        end
      end
    end
  end
end
