module Tracksale
  class Answer
    LIMIT = -1

    attr_accessor :time, :type, :name,
                  :email, :identification, :phone,
                  :nps_answer, :last_nps_answer, :nps_comment,
                  :campaign_name, :campaign_code, :id,
                  :deadline, :elapsed_time, :dispatch_time,
                  :reminder_time, :status, :tags,
                  :categories, :justifications

    def campaign
      Tracksale::Campaign.find_by_code(campaign_code)
    end

    class << self
      def all( start_time=(Time.now-86_400), end_time=(Time.now+86_400))
        raw_all(start_time,end_time).map { |answer| create_from_response(answer) }
      end

      def create_from_response(raw_response)
        new.tap do |answer|
          answer.time = Time.at(raw_response['time'].to_i)
          answer.type = raw_response['type']
          answer.name = raw_response['name']
          answer.email = raw_response['email']
          answer.identification = raw_response['identification']
          answer.phone = raw_response['phone']
          answer.nps_answer = raw_response['nps_answer']
          answer.last_nps_answer = raw_response['last_nps_answer']
          answer.nps_comment = raw_response['nps_comment']
          answer.campaign_name = raw_response['campaign_name']
          answer.campaign_code = raw_response['campaign_code']
          answer.id = raw_response['id']
          answer.deadline = raw_response['deadline']
          answer.elapsed_time = raw_response['elapsed_time']
          answer.dispatch_time = raw_response['dispatch_time']
          answer.reminder_time = raw_response['reminder_time']
          answer.status = raw_response['status']
          answer.tags = convert_tags(raw_response['tags'])
          answer.categories = raw_response['categories'].map { |c| c['name'] }
          answer.justifications = convert_justif(raw_response['justifications'])
        end
      end

      def raw_all( start_time=(Time.now-86_400), end_time=(Time.now+86_400))
        start_date = start_time.strftime('%Y-%m-%d')
        end_date = end_time.strftime('%Y-%m-%d')
        all_request = "report/answer?tags=true&limit=#{LIMIT}&start=#{start_date}&end=#{end_date}"

        client.get(all_request)
      end

      def client
        Tracksale.configuration.client.new
      end

      def convert_tags(tags)
        tags.map do |tag|
          { tag['name'] => tag['value'] }
        end.reduce(&:merge)
      end

      def convert_justif(multiple_answers)
        multiple_answers.map do |single_answer|
          {
            JSON.parse(single_answer['name']).values.first =>
              single_answer['children'].map { |c| JSON.parse(c).values.first }
          }
        end
      end
    end
  end
end
