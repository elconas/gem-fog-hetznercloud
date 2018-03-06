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

      end
    end
  end
end
