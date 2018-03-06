module Fog
  module Hetznercloud
    class Compute
      class Servers < Fog::Collection
        model Fog::Hetznercloud::Compute::Server

        def all(filters = {})
          servers = service.list_servers(filters).body['servers'] || []
          load(servers)
        end

        def get(identity)
          if (server = service.get_server(identity).body['server'])
            new(server)
          end
        rescue Fog::Hetznercloud::Compute::UnknownResourceError
          nil
        end

        def bootstrap(bootstap_timeout: 120, new_attributes: {}, ssh_keys:)
          require 'securerandom'

          defaults = {
            name: "hc-#{SecureRandom.hex(3)}",
            image: 'centos-7',
            server_type: 'cx11',
            ssh_keys: ssh_keys,
          }

          server = create(defaults.merge(new_attributes))

          status = false
          begin
            status = Timeout.timeout(bootstap_timeout) {
              server.wait_for { sshable?({ :auth_methods => %w(publickey)}) }
            }
          rescue Timeout::Error => e
            server.destroy()
            raise e
          end

          server

        end
      end
    end
  end
end
