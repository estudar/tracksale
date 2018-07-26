module Tracksale
  class DummyClient
    class << self
      attr_accessor :response # Easy way to force a response
    end

    def initialize
      puts 'running tracksale dummy client, do not expect real responses.' if $DEBUG
    end

    # maintaining the same method signature as the real client
    def get(_endpoint_path, _extra_headers = {})
      response
    end

    # maintaining the same method signature as the real client
    def post(_endpoint_path, _body, _extra_headers = {})
      response
    end

    def default_response_object
      response = {}

      def response.success?
        true
      end

      response
    end

    def response
      # definies a default valid response unless explicity defined.
      self.class.response || default_response_object
    end
  end
end
