module Fog
  module Hetznercloud
    module RequestHelper
      def create(path, body)
        request(method: :post,
                path: "/v1#{path}",
                body: body,
                expects: [201])
      end

      def get(path, query = {})
        request(method: :get,
                path: "/v1#{path}",
                query: query,
                expects: [200])
      end

      def update(path, body)
        request(method: :put,
                path: "/v1#{path}",
                body: body,
                expects: [200])
      end

      def delete(path)
        request(method: :delete,
                path: "/v1#{path}",
                expects: [200, 204])
      end
    end
  end
end
