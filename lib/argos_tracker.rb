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

    def merge_params(new_params)
      @data.merge!(new_params)
    end

    def prepare_request(params)
      options = ArgosTracker::Config.get_config
      report_error_config if options.empty?
      {
        url: options[:base_url],
        headers: {
          'Content-Type' => 'application/json'
        },
        body: body_request(options[:body], params),
        query: { api_key: options[:api_key] }
      }
    end

    def body_request(body, params) # rubocop:disable Metrics/AbcSize
      {
        channel: params[:channel] || params['channel'], source: body[:source], product: body[:product],
        utility_code: params[:utility_code] || params['utility_code'],
        timestamp: Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S.%LZ'), event_id: SecureRandom.uuid,
        event_category: params[:event_category], event_type: params[:event_type],
        user_id: params[:user_id] || params['user_id'],
        flow_user_id: params[:flow_user_id] || params['flow_user_id'],
        flow_id: params[:flow_id] || params['flow_id'], data: @data, user_external_id:
        params[:user_external_id] || params['user_external_id']
      }.compact
    end

    def send_request(http_verb, params)
      options = prepare_request(params)
      log(params, options)
      responses = HTTParty.send(http_verb, options[:url], query: options[:query], body: options[:body].to_json,
                                                          headers: options[:headers], timeout: options[:timeout])
      report_error_request(params) if responses.code != 200
      responses
    end

    def report_error_request(params)
      ArgosTracker::Config.get_config
      Rollbar.error('Argos response: Code error.',
                    utility: "Utility - CODE: #{params[:utility_code] || params['utility_code']}",
                    channel: params[:channel] || params['channel'], event_category: params[:event_category],
                    event_type: params[:event_type])
    end

    def report_error_config
      Rollbar.error('Argos config: Cannot obtain config')
    end

    def log(params, options)
      Rails.logger.info do
        "Utility_Id: #{params[:utility_code] || params['utility_code']}\n" \
        "Request -\n" \
        "url: #{options[:url]}\n" \
        "Query: #{options[:query]}\n" \
        "Header: #{options[:headers]}\n" \
        "Body: #{options[:body]}\n\n"
      end
    end
  end
end
