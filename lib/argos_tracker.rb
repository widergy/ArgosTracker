# frozen_string_literal: true

require_relative 'argos_tracker/version'
require 'argos_tracker/engine'
require 'argos_tracker/config'

module ArgosTracker
  class Error < StandardError; end

  class BaseArgosTracker
    attr_accessor :params, :response

    @params = {}

    def initialize(params = {})
      @params = params
      @response = nil
    end

    def merge_params(new_params)
      @params.merge!(new_params)
    end

    def prepare_request(product, channel, utility_code, event_category, event_type)
      options = ArgosTracker::Config.get_config(product)
      {
        url: options[:base_url],
        headers: {
          'api_key' => options[:api_key],
          'Content-Type' => 'application/json'
        },
        body: body_request(options, product, channel, utility_code, event_category, event_type)
      }
    end

    def body_request(options, product, channel, utility_code, event_category, event_type, flow_user_id = nil, flow_id = nil)
      {
        channel: channel, source: options[:source], product: options[:product],
        utility_code: utility_code, timestamp: Time.now.to_i, event_category: event_category,
        event_type: event_type, flow_user_id: flow_user_id, flow_id: flow_id, data: params
      }
    end

    def send_request(http_verb, product, channel, utility_code, event_category, event_type)
      options = prepare_request(product, channel, utility_code, event_category, event_type)
      byebug
      HTTParty.send(http_verb, options[:url], query: options[:query], body: options[:body],
                    headers: options[:headers], timeout: options[:timeout])
    end
  end
  