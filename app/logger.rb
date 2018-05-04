require "logger"
require "time"

module SleepWarm
  class AccessLogger < ::Logger
    def initialize(*args)
      super
      @formatter = AccessLogFormatter.new
    end
  end

  class AccessLogFormatter < ::Logger::Formatter
    def call(_, time, _, msg)
      "[#{time.iso8601}] #{msg[:client_ip]} #{msg[:hostname]} \"#{msg[:request_line]} #{msg[:version]}\" #{msg[:status_code]} #{msg[:rule_id]} #{msg[:all]}\n"
    end
  end

  class ApplicationLogger < ::Logger; end
end
