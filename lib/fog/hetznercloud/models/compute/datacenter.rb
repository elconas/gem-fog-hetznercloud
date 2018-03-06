# https://docs.hetzner.cloud/#resources-actions-get
module Fog
  module Hetznercloud
    class Compute
      class Datacenter < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :location
        attribute :server_types

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
      end
    end
  end
end
