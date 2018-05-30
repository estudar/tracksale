module Tracksale
  class Client
    attr_accessor :key
    attr_accessor :default_path
    include HTTParty
    # api.tracksale.co/v2/login
    base_uri 'http://api.tracksale.co'

    def initialize
      if Tracksale.configuration.key.nil?
        raise 'API Key not found , please configure as explained in the readme.'
      end

      @key = Tracksale.configuration.key
      @default_path = '/v2/'
      @client = HTTParty
    end

    def get(endpoint_path, extra_headers = {})
      headers = { 'authorization' => 'bearer ' + key }.merge(extra_headers)
      request_params = {
        headers: headers
      }
      request_params[:debug_output] = STDOUT if $DEBUG
      self.class.get(default_path + endpoint_path, request_params)
    end
  end
end
