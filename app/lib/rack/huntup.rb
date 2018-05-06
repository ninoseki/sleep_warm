require "base64"

module Rack
  class HuntUp < BaseUp

    attr_reader :app
    attr_accessor :hunting_logger
    attr_accessor :application_logger
    attr_reader :hunter

    def initialize(app, &instance_configure)
      @app = app
      @hunter = SleepWarm::Hunter.new
      @hunting_loggfer = self.class.config.hunting_logger
      @application_logger = self.class.config.application_logger
      instance_configure.call(self) if block_given?
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

      hunt = hunter.hunt(request_info(req))
      p hunt if hunt

      res.finish
    end
  end
end

