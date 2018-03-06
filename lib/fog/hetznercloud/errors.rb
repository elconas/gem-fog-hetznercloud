module Fog
  module Hetznercloud
    module Errors
      def self.decode_error(error)
        body = begin
                 Fog::JSON.decode(error.response.body)
               rescue Fog::JSON::DecodeError
                 nil
               end

        return if body.nil?

        code    = body['error']['code']
        message = body['error']['message']
        details = body['error']['details']

        return if code.nil? || message.nil?

        unless details.nil?
          message << "\n"
          message << format_details(details)
        end

        { code: code, message: message }
      end

      def self.format_details(details)
        details.map { |field, msgs| format_field(field, msgs) }.join("\n")
      end

      def self.format_field(field, msgs)
        msgs = msgs.map { |msg| "\t\t- #{msg}" }
        "\t#{field}:\n#{msgs.join("\n")}"
      end
    end
  end
end
