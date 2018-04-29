# This is a fork of https://github.com/udzura/rack-spyup.

require "logger"
require "base64"

module Rack
  class SpyUp

    attr_reader :app
    attr_accessor :logger

    def initialize(app, &instance_configure)
      @app = app
      @logger = self.class.config.logger
      instance_configure.call(self) if block_given?
    end

    def call(env)
      req = Rack::Request.new(env)

      status_code, headers, body = @app.call(env)
      res = Rack::Response.new(body, status_code, headers)

      logger.info log_message(req, res)

      res.finish
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

    private

    def log_message(req, res)
      # [{time}] {clientip} {hostname} \"{requestline}\" {status_code} {match_result} {requestall}
      {
        client_ip: req.env["REMOTE_ADDR"],
        hostname: req.host,
        request_line: request_line(req),
        status_code: res.status,
        match_result: nil,
        encoded_request: Base64.strict_encode64(dump_request(req))
      }
    end

    def dump_request(req)
      arr = []
      arr << request_line(req)
      arr += request_headers(req)

      body = body(req)
      unless body.empty?
        arr << ""
        arr << body
      end
      arr.join("\n")
    end

    def body(req)
      req.body.read
    end

    def request_line(req)
      "#{req.request_method} #{req.url}"
    end

    def request_headers(req)
      headers = []
      headers << "Content-Type: #{req.content_type}" if req.content_type
      headers << "Content-Length: #{req.content_length}" if req.content_length.to_i.positive?
      req.env.each do |key, value|
        next unless key.include? "HTTP_"
        parts = key.scan(/^HTTP_([A-Z_]+)/).flatten.first
        _key = parts.split('_').map do |part|
          part.sub(/(?<=^[A-Z])[A-Z]*/) { |m| m.downcase }
        end.join("-")
        headers << "#{_key}: #{value}"
      end
      headers.sort
    end
  end
end

