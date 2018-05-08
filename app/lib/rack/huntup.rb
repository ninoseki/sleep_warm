require "base64"

module Rack
  class HuntUp < BaseUp

    attr_reader :app
    attr_reader :hunter
    attr_accessor :hunting_logger
    attr_accessor :application_logger

    def initialize(app, &instance_configure)
      @app = app
      @hunter = SleepWarm::Hunter.new
      @hunting_loggfer = self.class.config.hunting_logger
      @application_logger = self.class.config.application_logger
      instance_configure.call(self) if block_given?

      bootstrap_logging
    end

    class << self
      def config(&global_configure)
        @__config ||= Rack::HuntUp::Configuration.default
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

      hits = hunter.hunt(request_info(req))
      hunting_logger.info hunting_info(req, hits) if hits
      res.finish
    end

    private

    def bootstrap_logging
      application_logger.info "#{hunter.rules.length} hunting rule(s) loaded"
    end

    # Returns a hunting information for logging.
    #
    # @param [Rack::Request] req
    # @param [Array<String>] hits
    # @return [Hash]
    def hunting_info(req, hits)
      {
        client_ip: req.env["REMOTE_ADDR"],
        hits: hits
      }
    end
  end
end

