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

        # Sets the proc used to determine the IP Address used for ssh/scp interactions.
        # @example
        #   service.servers.bootstrap :name => "bootstrap-server",
        #                             :image => service.flavors.first.id,
        #                             :server_type => service.server_types.all(:name => 'cx11').identity,
        #                             :private_key_path => "~/.ssh/fog_rsa",
        #                             :user_data => "./file",
        #                             :location => 'nbg1',
        #                             :ssh_keys => [ 'keyname' ],
        #                             :bootstap_timeout => 120
        #
        # @note
        #   When booting without ssh_keys set, bootstrapping will wait
        #   until the server is read and not until you can ssh into the server
        #   Bootstrapping waits until bootstap_timeout seconds and then destroy
        #   the server. Default timeout is 120 seconds, which should be ok
        #   unless you have a lot of user-data scripts.
        def bootstrap(new_attributes = {})
          require 'securerandom'

          defaults = {
            name: "hc-#{SecureRandom.hex(3)}",
            image: 'centos-7',
            server_type: 'cx11'
          }

          bootstap_timeout = new_attributes[:bootstap_timeout].nil? ? 120 : new_attributes[:bootstap_timeout]

          server = create(defaults.merge(new_attributes))

          # if ssh keys are provided wait until we can SSH the server
          # othwise just wait till the server is ready as we will never
          # be able to login
          status = false
          begin
            status = Timeout.timeout(bootstap_timeout) do
              if new_attributes[:ssh_keys].nil?
                server.wait_for { ready? }
              else
                server.wait_for { sshable?(auth_methods: %w[publickey]) }
              end
            end
          rescue Timeout::Error => e
            server.destroy
            raise e
          end

          server
        end
      end
    end
  end
end
