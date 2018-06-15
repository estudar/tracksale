module Tracksale
  class Campaign
    attr_accessor :name, :code, :score

    def schedule_dispatch(body)
      self.class.schedule_dispatch(code, body)
    end

    def self.schedule_dispatch(code, body)
      response = client.post('campaign/' + code.to_s + '/dispatch', body)

      return response if response.success?

      raise ArgumentError, response['error'] if response['error']
      raise response.response.error!
    end

    def self.find_by_name(name)
      campaign_found_by_name = raw_all.keep_if { |c| c['name'] == name }.first
      return nil if campaign_found_by_name.nil?
      create_from_response(campaign_found_by_name)
    end

    def self.all
      raw_all.map { |campaign| create_from_response(campaign) }
    end

    def self.create_from_response(raw_reponse)
      new.tap do |campaign|
        campaign.name = raw_reponse['name']
        campaign.code = raw_reponse['code']
        campaign.score = {
          detractors: raw_reponse['detractors'],
          passives: raw_reponse['passives'],
          promoters: raw_reponse['promoters']
        }
      end
    end

    def self.raw_all
      client.get('campaign')
    end

    def self.client
      Tracksale::Client.new
    end
  end
end
