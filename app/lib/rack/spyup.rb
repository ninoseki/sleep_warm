# This is a fork of https://github.com/udzura/rack-spyup.

require "base64"

module Rack
  class SpyUp < BaseUp

    attr_reader :app
    attr_accessor :access_logger
    attr_accessor :application_logger
    attr_reader :mrr

    def initialize(app, &instance_configure)
      @app = app
      @mrr = SleepWarm::MRR.new
      @access_logger = self.class.config.access_logger
      @application_logger = self.class.config.application_logger
      instance_configure.call(self) if block_given?

      bootstrap_logging
    end

    class << self
      def config(&global_configure)
        @__config ||= Rack::SpyUp::Configuration.default
        if block_given?
          global_configure.call(@__config)
        end
        @__config
      end
    end

    def call(env)
      req = Rack::Request.new(env)
      status_code, header, body = @app.call(env)
      res = Rack::Response.new(body, status_code, header)

      matched_rule = mrr.find({ method: req.request_method, uri: req.url, header: req.env.to_s, body: body(req) })
      res = response_from_rule(matched_rule) if matched_rule

      access_logger.info access_info(req, res, matched_rule)

      res.finish
    end

    # Returns a Rack::Response based on a SleepWarm::Rule
    #
    # @param [SleepWarm::Rule] rule
    # @return [Rack::Response]
    def response_from_rule(rule)
      body = rule.response.dig("body") || ""
      status = rule.response.dig("status") || 200
      header = rule.response.dig("header") || {}
      Rack::Response.new(body, status, header)
    end

    private

    # Logging application log
    def bootstrap_logging
      application_logger.info "SleepWarm is started."
      application_logger.info "#{mrr.valid_rules.length} rule(s) loaded."
      application_logger.info "#{mrr.invalid_rules.length} rule(s) failed to load: #{mrr.invalid_rules.map(&:path).join(',')}." unless mrr.invalid_rules.empty?
    end

    # Returns an access information for logging.
    #
    # @param [Rack::Request] req
    # @param [Rack::Response] res
    # @param [SleepWarm::Rule] rule
    # @return [Hash]
    def access_info(req, res, rule)
      {
        client_ip: req.env["REMOTE_ADDR"],
        hostname: req.host_with_port,
        request_line: request_line(req),
        version: req.env["HTTP_VERSION"],
        status_code: res.status,
        match_result: rule ? rule.id : "None",
        encoded_request: base64_encoded_request(req)
      }
    end
  end
end

