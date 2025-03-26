# frozen_string_literal: true

require_relative 'argos_tracker/version'
require 'argos_tracker/engine'
require 'argos_tracker/config'
require 'securerandom'

module ArgosTracker
  class Error < StandardError; end

  class BaseArgosTracker # rubocop:disable Style/Documentation
    attr_accessor :params, :response

    @data = {}

    def initialize(data = {})
      @data = data
      @response = nil
    end

    def self.check_header_async(polling_header)
      polling_header.present?
    end

    def self.track_event?(track_event)
      track_event.present?
    end

    def merge_params(new_params)
      @data.merge!(new_params)
    end

    def prepare_request(params)
      options = ArgosTracker::Config.get_config
      report_error_config if options.empty?
      {
        url: options[:base_url],
        headers: {
          'api_key' => options[:api_key], 'Content-Type' => 'application/json'
        },
        body: body_request(options, params, nil, nil)
      }
    end

    def body_request(options, params)
      {
        channel: params[:channel], source: options[:source], product: options[:product],
        utility_code: params[:utility_code], timestamp: Time.now.to_i, event_id: SecureRandom.uuid,
        event_category: params[:event_category], event_type: params[:event_type], user_id: params[:user_id],
        flow_user_id: params[:flow_user_id], flow_id: params[:flow_id] || nil, data: data,
        user_external_id: params[:user_external_id]
      }.compact
    end

    def send_request(http_verb, params)
      options = prepare_request(params)
      responses = HTTParty.send(http_verb, options[:url], query: options[:query], body: options[:body],
                                                          headers: options[:headers], timeout: options[:timeout])
      report_error_request(params, response) if responses.code != 200
      responses
    end

    def report_error_request(channel, utility_code, event_category, event_type)
      ArgosTracker::Config.get_config
      Rollbar.error('Argos response: Code error.', utility: "Utility - CODE: #{utility_code}",
                                                   channel: channel, event_category: event_category,
                                                   event_type: event_type)
    end

    def report_error_config
      Rollbar.error('Argos config: Cannot obtain config')
    end
  end
end
