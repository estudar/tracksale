module Tracksale
  class Configuration
    attr_accessor :key
    attr_accessor :client

    def client
      @client ||= Tracksale::Client
    end

    def force_dummy_client(on = true)
      @client = on ?
        Tracksale::DummyClient :
        Tracksale::Client
    end
  end
end
