require 'fog/hetznercloud/client'
require 'fog/hetznercloud/errors'
require 'fog/hetznercloud/request_helper'

module Fog
  module Hetznercloud
    class Compute < Fog::Service
      class UnauthorizedError < Error; end
      class ForbiddenError < Error; end
      class InvalidInputError < Error; end
      class JsonErrorError < Error; end
      class LockedError < Error; end
      class NotFoundError < Error; end
      class RateLimitExceededError < Error; end
      class ResourceLimitExeceededError < Error; end
      class ResourceUnavailableError < Error; end
      class ServiceErrorError < Error; end
      class UniquenessErrorError < Error; end
      class UnknownResourceError < Error; end
      class StateError < Error; end

      requires   :hetznercloud_token
      recognizes :hetznercloud_datacenter
      recognizes :hetznercloud_location
      secrets    :hetznercloud_token

      model_path 'fog/hetznercloud/models/compute'

      model      :server
      collection :servers
      model      :image
      collection :images
      model      :server_type
      collection :server_types
      model      :action
      collection :actions
      model      :floating_ip
      collection :floating_ips
      model      :location
      collection :locations
      model      :datacenter
      collection :datacenters
      model      :ssh_key
      collection :ssh_keys

      request_path 'fog/hetznercloud/requests/compute'

      ## Servers
      request :create_server
      request :list_servers
      request :get_server
      request :update_server
      request :delete_server
      request :execute_server_action

      # Server Types
      request :list_server_types
      request :get_server_type

      # Images
      request :list_images
      request :get_image
      request :delete_image
      request :update_image

      # Actions
      request :list_actions
      request :get_action

      # Locations
      request :list_locations
      request :get_location

      # Datacenters
      request :list_datacenters
      request :get_datacenter

      # Datacenters
      request :list_ssh_keys
      request :get_ssh_key
      request :create_ssh_key
      request :delete_ssh_key
      request :update_ssh_key

      # Floating IP'S
      request :list_floating_ips
      request :get_floating_ip
      request :create_floating_ip
      request :delete_floating_ip
      request :update_floating_ip
      request :floating_ip_assign_to_server
      request :floating_ip_unassign
      request :floating_ip_update_dns_ptr

      class Real
        include Fog::Hetznercloud::RequestHelper

        # FIXME: Make @location and @datacenter used in server creation
        #        as default
        def initialize(options)
          @token              = options[:hetznercloud_token]
          @location           = options[:hetznercloud_location] || 'fsn1'
          @datacenter         = options[:hetznercloud_datacenter] || 'fsn1-dc8'
          @connection_options = options[:connection_options] || {}
        end

        def request(params)
          client.request(params)
        rescue Excon::Errors::HTTPStatusError => error
          decoded = Fog::Hetznercloud::Errors.decode_error(error)
          raise if decoded.nil?

          code    = decoded[:code]
          message = decoded[:message]

          raise case code
          when 'unauthorized', 'forbidden', 'invalid_input', 'json_error', 'locked', 'not_found', 'rate_limit_exceeded', 'resource_limit_exceeded', 'resource_unavailable', 'service_error', 'uniqueness_error'
                  Fog::Hetznercloud::Compute.const_get("#{camelize(code)}Error").slurp(error, message)
                else
                  Fog::Hetznercloud::Compute::Error.slurp(error, message)
                end
        end

        private

        def client
          @client ||= Fog::Hetznercloud::Client.new(endpoint, @token, @connection_options)
        end

        def endpoint
          "https://api.hetzner.cloud/v1"
        end

        def camelize(str)
          str.split('_').collect(&:capitalize).join
        end
      end

      class Mock
        def request(*args)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end
