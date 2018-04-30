module SleepWarm
  class Logger < ::Logger
    def initialize(*args)
      super
      @formatter = Formatter.new
    end
  end

  class Formatter < ::Logger::Formatter
    def call(_, time, _, msg)
      "[#{time}] #{msg[:client_ip]} #{msg[:hostname]} \"#{msg[:request_line]}\" #{msg[:status_code]} #{msg[:match_result]} #{msg[:encoded_request]}\n"
    end
  end
end
