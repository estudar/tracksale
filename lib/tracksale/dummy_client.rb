module Tracksale
  class DummyClient
    class << self
      attr_accessor :response #Easy way to force a response
    end

    def initialize
      puts 'running tracksale dummy client, do not expect real responses.' if $DEBUG
    end

    def get(endpoint_path, extra_headers = {}) #maintaining the same method signature as the real client
      self.response
    end

    def post(endpoint_path, body, extra_headers = {}) #maintaining the same method signature as the real client
      self.response
    end

    def default_response_object
      response = {}

      def response.success?
        true
      end

      return response
    end

    def response
      #definies a default valid response unless explicity defined.
      self.class.response || default_response_object
    end
  end
end
