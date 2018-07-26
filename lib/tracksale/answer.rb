# -*- coding: utf-8 -*-
module Tracksale
  class Answer
    LIMIT=-1

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
      def all
        raw_all.map { |answer| create_from_response(answer) }
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
          answer.justifications = convert_list_to_objects(raw_response['justifications'])
        end
      end

      def raw_all
        client.get('report/answer?tags=true&limit=' + LIMIT.to_s)
      end

      def client
        Tracksale.configuration.client.new
      end

      def convert_tags(tags)
        tags.map { |tag|
          { tag['name'] => tag['value'] }
        }.reduce(&:merge)
      end

      def convert_list_to_objects(multiple_answers)
        multiple_answers.map do |single_answer|
          {
            JSON.load(single_answer['name']).values.first =>
              single_answer['children'].map { |child| JSON.load(child).values.first}
          }
        end
      end
    end
  end
end
