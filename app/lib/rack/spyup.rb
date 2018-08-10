module Rack
  class SpyUp < BaseUp
    attr_reader :app
    attr_accessor :logger
    attr_reader :mrr

    # @param [#call] app
    # @param [Proc] instance_configure
    def initialize(app, &instance_configure)
      @app = app
      @mrr = SleepWarm::MRR.new
      @logger = self.class.config.logger

      instance_configure.call(self) if block_given?

      bootstrap_logging
    end

    class << self
      # Returns a configuration
      #
      # @param [Proc] global_configure
      # return [Rack::SpyUp::Configuration]
      def config(&global_configure)
        @__config ||= Rack::SpyUp::Configuration.default
        global_configure.call(@__config) if block_given?
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

      matched_rule = mrr.find({ method: req.request_method, uri: req.url, header: req.env.to_s, body: body(req) })
      res = response_from_rule(matched_rule) if matched_rule

      logger.tagged("access") { logger.info access_info(req, res, matched_rule) }

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
      logger.tagged("application") { logger.info "#{mrr.valid_rules.length} matching rule(s) loaded." }
      logger.tagged("application") { logger.info "#{mrr.invalid_rules.length} matching rule(s) failed to load: #{mrr.invalid_rules.map(&:path).join(',')}." } unless mrr.invalid_rules.empty?
    end

    # Returns an access information for logging.
    #
    # @param [Rack::Request] req
    # @param [Rack::Response] res
    # @param [SleepWarm::Rule] rule
    # @return [Hash]
    def access_info(req, res, rule)
      {
        client_ip: req.env["HTTP_X_FORWARDED_FOR"] || req.env["REMOTE_ADDR"],
        hostname: req.host_with_port,
        request_line: request_line(req),
        version: req.env["HTTP_VERSION"],
        status_code: res.status,
        rule_id: rule ? rule.id : "None",
        all: base64_encoded_request(req)
      }
    end
  end
end
