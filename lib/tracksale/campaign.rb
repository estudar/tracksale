module Tracksale
  class Campaign
    attr_accessor :name, :code, :score

    def self.find_by_name(name)
      campaign_found_by_name = raw_all.keep_if{|campaign| campaign['name'] == name }.first
      return nil if campaign_found_by_name.nil?
      create_from_response(campaign_found_by_name)
    end

    def self.all
      raw_all.map{ |campaign| create_from_response(campaign) }
    end

    def self.create_from_response(raw_reponse)
      self.new.tap{ |campaign|
        campaign.name = raw_reponse['name']
        campaign.code = raw_reponse['code']
        campaign.score = {
          detractors: raw_reponse['detractors'],
          passives: raw_reponse['passives'],
          promoters: raw_reponse['promoters']
        }
      }
    end

    private

    def self.raw_all
      client.get('campaign')
    end

    def self.client
      Tracksale::Client.new
    end
  end
end
