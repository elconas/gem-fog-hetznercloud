# https://docs.hetzner.cloud/#resources-actions-get
module Fog
  module Hetznercloud
    class Compute
      class SshKey < Fog::Model
        identity :id

        attribute :name
        attribute :fingerprint
        attribute :public_key

        def destroy
          requires :identity

          service.delete_ssh_key(identity)
          true
        end

        def public_key=(value)
          attributes[:public_key] = if value =~ /^\.?\/[^\/]+/
                                      File.read(value)
                                    else
                                      value
                                    end
        end

        def save
          if persisted?
            update
          else
            create
          end
        end

        private

        def create
          requires :name, :public_key

          if (ssh_key = service.create_ssh_key(name, public_key).body['ssh_key'])
            merge_attributes(ssh_key)
            true
          else
            false
          end
        end

        def update
          requires :identity, :name

          body = attributes.dup

          body[:name] = name

          if (ssh_key = service.update_ssh_key(identity, body).body['ssh_key'])
            merge_attributes(ssh_key)
            true
          else
            false
          end
        end
      end
    end
  end
end
