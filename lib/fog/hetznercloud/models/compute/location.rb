# https://docs.hetzner.cloud/#resources-actions-get
module Fog
  module Hetznercloud
    class Compute
      class Location < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :country
        attribute :city
        attribute :latitude
        attribute :longitude
      end
    end
  end
end
