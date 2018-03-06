# https://docs.hetzner.cloud/#resources-actions-get
module Fog
  module Hetznercloud
    class Compute
      class Action < Fog::Model
        identity :id

        attribute :command
        attribute :status
        attribute :progress
        attribute :started
        attribute :finished
        attribute :resources
        attribute :error

        def running?
          status == 'running'
        end

        def error?
          status == 'error'
        end

        def success?
          status == 'success'
        end
      end
    end
  end
end
