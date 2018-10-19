require 'fog/compute/models/server'

module Fog
  module Hetznercloud
    class Compute
      class Server < Fog::Compute::Server
        identity :id

        # Required
        attribute :name
        attribute :image
        attribute :server_type

        attribute :status
        attribute :created
        attribute :user_data
        attribute :ssh_keys
        attribute :public_net
        attribute :datacenter
        attribute :location
        attribute :iso
        attribute :rescue_enabled
        attribute :locked
        attribute :backup_window
        attribute :start_after_create
        attribute :outgoing_traffic
        attribute :incoming_traffic
        attribute :included_traffic
        attribute :labels

        def initialize(options)
          @async = true
          super(options)
        end

        def image=(value)
          attributes[:image] = case value
                               when Hash
                                 service.images.new(value)
                               when String
                                 service.images.all(name: value).first
                               when Integer
                                 service.images.get(value)
                               else
                                 value
                               end
        end

        def ssh_keys=(value)
          attributes[:ssh_keys] = []
          # API does not return ssh_key
          return true if value.nil?
          value.each do |item|
            thing = case item
                    when Hash
                      service.ssh_keys.new(item)
                    when String
                      service.ssh_keys.all(name: item).first
                    when Integer
                      service.ssh_keys.get(item)
                    else
                      value
                               end
            attributes[:ssh_keys] << thing
          end
        end

        def server_type=(value)
          attributes[:server_type] = case value
                                     when Hash
                                       service.server_types.new(value)
                                     when String
                                       service.server_types.all(name: value).first
                                     when Integer
                                       service.server_types.get(value)
                                     else
                                       value
                               end
        end

        def location=(value)
          attributes[:location] = case value
                                  when Hash
                                    service.locations.new(value)
                                  when String
                                    service.locations.all(name: value).first
                                  when Integer
                                    service.locations.get(value)
                                  else
                                    value
                                   end
        end

        def datacenter=(value)
          attributes[:datacenter] = case value
                                    when Hash
                                      service.datacenters.new(value)
                                      attributes[:location] = service.locations.new(value['location'])
                                    when String
                                      service.datacenters.all(name: value).first
                                    when Integer
                                      service.datacenters.get(value)
                                    else
                                      value
                                        end
        end

        def user_data=(value)
          attributes[:user_data] = if value =~ /^(\.|~)?\/[^\/]+/
                                     File.read(value)
                                   else
                                     value
                                   end
        end

        def name=(value)
          return true if name == value
          @needsupdate = true
          attributes[:name] = value
        end

        def public_dns_name
          "static.#{public_net['ipv4']['ip']}.clients.your-server.de"
        end

        def reverse_dns_name
          public_net['ipv4']['dns_ptr']
        end

        def ready?
          status == 'running'
        end

        def migrating?
          status == 'migrating'
        end

        def stopped?
          status == 'off'
        end

        def save
          if persisted?
            update
          else
            create
          end
        end

        def destroy
          requires :identity

          service.delete_server(identity)
          true
        end

        def poweron(async: async_mode?)
          requires :identity

          execute_action('poweron', async)
        end

        def poweroff(async: async_mode?)
          requires :identity

          execute_action('poweroff', async)
        end

        def reboot(async: async_mode?)
          requires :identity

          execute_action('reboot', async)
        end

        def reset(async: async_mode?)
          requires :identity

          execute_action('reset', async)
        end

        def shutdown(async: async_mode?)
          requires :identity

          execute_action('shutdown', async)
        end

        def async=(value)
          @async = !!value
        end

        def async?
          @async
        end

        def async_mode?
          async?
        end

        def sync=(value)
          @async = !value
        end

        def sync?
          !@async
        end

        def disable_rescue(async: async_mode?)
          requires :identity

          execute_action('disable_rescue', async)
        end

        def enable_rescue(type: 'linux64', ssh_keys: [], async: async_mode?)
          requires :identity

          # FIXME: Refactor with ssh_keys=(value) above to do DRY
          sshkeys = []
          ssh_keys.each do |item|
            thing = case item
                    when Hash
                      service.ssh_keys.new(item)
                    when String
                      service.ssh_keys.all(name: item).first
                    when Integer
                      service.ssh_keys.get(item)
                    else
                      value
                               end
            sshkeys << thing.identity
          end

          body = {
            type: type,
            ssh_keys: sshkeys
          }

          execute_action('enable_rescue', async, body)
        end

        # Returns action, imageObject
        def create_backup(async: async_mode?, description: "Backup of #{attributes[:name]} created at #{Time.now}")
          requires :identity

          create_image(async: async, description: description, type: 'backup')
        end

        # Returns action, imageObject
        def create_image(async: async_mode?, description: "image of #{attributes[:name]} created at #{Time.now}", type: 'snapshot')
          requires :identity

          body = {
            description: description,
            type: type
          }

          execute_action('create_image', async, body)
        end

        def rebuild_from_image(async: async_mode?, image:)
          requires :identity

          # FIXME: Lookup images by description. As API does not support
          #        this we need to filter our own. Probably needs pagination
          #        support.
          image_id = case image
                     when Fog::Hetznercloud::Compute::Image
                       image.identity
                     when Integer
                       image
                                end

          body = {
            image: image_id
          }

          execute_action('rebuild', async, body)
        end

        def change_type(async: async_mode?, upgrade_disk: false, server_type:)
          requires :identity

          # FIXME: Should I shutdown and wait here as server needs to
          #        be stopped ?

          body = {
            upgrade_disk: upgrade_disk,
            server_type: server_type
          }

          execute_action('change_type', async, body)
        end

        def enable_backup(async: async_mode?, backup_window: nil)
          requires :identity

          unless backup_window.nil?
            body = {
              backup_window: backup_window
            }
          end

          execute_action('enable_backup', async, body)
        end

        def change_dns_ptr(dns_ptr, ip: public_ip_address, async: async_mode?)
          requires :identity

          body = {
            ip: ip,
            dns_ptr: dns_ptr
          }

          execute_action('change_dns_ptr', async, body)
        end

        def disable_backup(async: async_mode?)
          requires :identity

          execute_action('disable_backup', async)
        end

        # Returns action, password
        def reset_root_password(async: async_mode?)
          requires :identity
          unless ready?
            throw Fog::Hetznercloud::Error::StateError.new('ERROR: to reset the root password, the server must be running')
          end

          execute_action('reset_password', async)
        end

        def execute_action(action, async = true, body = {})
          requires :identity

          request_body = service.execute_server_action(identity, action, body).body
          if (action = request_body['action'])
            service.actions.new(action).tap do |a|
              unless async
                a.wait_for { a.success? }
                reload
              end
            end
          end
          extra = service.images.new(request_body['image']) unless request_body['image'].nil?
          extra = request_body['root_password'] unless request_body['root_password'].nil?
          [action, extra]
        end

        def public_ip_address
          public_net['ipv6']['ip'] if public_net.key?('ipv6')
          public_net['ipv4']['ip'] if public_net.key?('ipv4')
        end

        private

        def create
          requires :name, :server_type, :image

          options = {}
          options[:ssh_keys] = ssh_keys.map(&:identity) unless ssh_keys.nil?
          options[:user_data] = user_data unless user_data.nil?
          options[:start_after_create] = start_after_create unless start_after_create.nil?
          options[:labels] = labels unless labels.nil?
          options[:location] = location.identity unless location.nil?
          options[:datacenter] = datacenter.identity unless datacenter.nil?

          if (server = service.create_server(name, image.identity, server_type.identity, options).body['server'])
            merge_attributes(server)
            true
          else
            false
          end
        end

        def update
          requires :identity, :name
          return true unless @needsupdate

          body = attributes.dup

          body = {
            name: name
          }

          if (server = service.update_server(identity, body).body['server'])
            merge_attributes(server)
            true
          else
            false
          end
        end
      end
    end
  end
end
