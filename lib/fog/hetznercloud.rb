require 'fog/core'
require 'fog/json'
require 'fog/hetznercloud/version'

module Fog
  module Hetznercloud
    extend Fog::Provider

    autoload :Compute, File.expand_path('../hetznercloud/compute', __FILE__)

    service :compute, 'Compute'
  end
end
