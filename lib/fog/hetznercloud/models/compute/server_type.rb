module Fog
  module Hetznercloud
    class Compute
      class ServerType < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :cores
        attribute :memory
        attribute :disk
        attribute :prices
        attribute :storage_type
      end
    end
  end
end
