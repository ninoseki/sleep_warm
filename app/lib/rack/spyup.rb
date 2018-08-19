# frozen_string_literal: true

module Rack
  class SpyUp < BaseUp
    attr_reader :app
    attr_accessor :logger
    attr_reader :mrr

    # @param [#call] app
    # @param [Proc] instance_configure
    def initialize(app)
      @app = app
      @mrr = SleepWarm::MRR.new
      @logger = self.class.config.logger

      yield(self) if block_given?

      startup_information
    end

    class << self
      # Returns a configuration
      #
      # @param [Proc] global_configure
      # return [Rack::SpyUp::Configuration]
      def config
        @__config ||= Rack::SpyUp::Configuration.default
        yield(@__config) if block_given?
        @__config
      end
    end

    # @param  [Hash{String => String}] env
    # @return [Array(Integer, Hash, #each)]
    # @see    http://rack.rubyforge.org/doc/SPEC.html
    def call(env)
      req = Rack::Request.new(env)
      status_code, header, body = @app.call(env)
      res = Rack::Response.new(body, status_code, header)

      input = { method: req.request_method, uri: req.url, header: req.env.to_s, body: request_body(req) }
      matched_rule = mrr.find(input)
      res = response_from_rule(matched_rule) if matched_rule

      logger.info access_info(req, res, matched_rule)

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

    def startup_information
      STDOUT.puts "#{mrr.valid_rules.length} matching rule(s) loaded."
      STDERR.puts "#{mrr.invalid_rules.length} matching rule(s) failed to load: #{mrr.invalid_rules.map(&:path).join(',')}." unless mrr.invalid_rules.empty?
    end

    # Returns an access information for logging.
    #
    # @param [Rack::Request] req
    # @param [Rack::Response] res
    # @param [SleepWarm::Rule] rule
    # @return [Hash]
    def access_info(req, res, rule)
      info = {
        client_ip: req.env["HTTP_X_FORWARDED_FOR"] || req.env["REMOTE_ADDR"],
        hostname: req.host_with_port,
        request_line: request_line(req),
        version: req.env["HTTP_VERSION"],
        status_code: res.status,
        rule_id: rule ? rule.id : 0,
        all: base64_encoded_request(req),
        type: "sleep-warm-access"
      }
      info[:message] = "#{info[:client_ip]} #{info[:hostname]} \"#{info[:request_line]} #{info[:version]}\" #{info[:status_code]} #{info[:rule_id]}"

      info
    end
  end
end
