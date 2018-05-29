module Tracksale
  class Campaign
    def self.find_by_name(name)
      all.keep_if{|campaign| campaign['name'] == name }
    end

    def self.all
      client.get('campaign')
    end

    private

    def self.client
      Tracksale::Client.new
    end
  end
end
