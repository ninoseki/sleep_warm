require "logger"
require "time"

module SleepWarm

  class ApplicationLogger < ::Logger; end

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

  class HuntingLogger < ::Logger
    def initialize(*args)
      super
      @formatter = HuntingLogFormatter.new
    end
  end

  class HuntingLogFormatter < ::Logger::Formatter
    def call(_, time, _, msg)
      hits = msg[:hits].join(",")
      "[#{time.iso8601}] #{msg[:client_ip]} #{hits}\n"
    end
  end
end
