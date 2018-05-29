module Tracksale
  class Client
    attr_accessor :key
    attr_accessor  :default_path
    include HTTParty
    # api.tracksale.co/v2/login
    base_uri 'http://api.tracksale.co'

    def initialize
      @key = Tracksale.configuration.key
      @default_path = '/v2/'
      @client = HTTParty
    end

    def get(endpoint_path,extra_headers = {})
      headers = {"authorization" => 'bearer '+key}.merge(extra_headers)
      self.class.get(default_path+endpoint_path, {
        headers: headers,
        debug_output: STDOUT,
      })
    end
  end
end
