module Fog
  module Hetznercloud
    class Compute
      class Image < Fog::Model
        identity :id

        attribute :type
        attribute :status
        attribute :name
        attribute :description
        attribute :image_size
        attribute :disk_size
        attribute :created
        attribute :created_from
        attribute :bound_to
        attribute :os_flavor
        attribute :os_version
        attribute :rapid_deploy

        def created=(value)
          attributes[:created] = Time.iso8601(value)
        end

        def created_from=(value)
          attributes[:created_from] = case value
                                        when Hash
                                          service.servers.new(value)
                                        when Integer
                                          service.servers.new(identity: value)
                                        else
                                          value
                                        end
        end

        def bound_to=(value)
          attributes[:bound_to] = case value
                                        when Hash
                                          service.servers.new(value)
                                        when Integer
                                          service.servers.new(identity: value)
                                        else
                                          value
                                        end
        end

        def save
          update
        end

        def destroy
          requires :identity

          service.delete_image(identity)
          true
        end

        private

        def update
          requires :identity
          requires_one :description, :type

          body = attributes.dup

          body[:description] = description
          body[:type] = type

          if (image = service.update_image(identity, body).body['image'])
            merge_attributes(image)
            true
          else
            false
          end
        end


      end
    end
  end
end
