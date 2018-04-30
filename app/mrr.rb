require "yaml"

module SleepWarm
  class MRR
    def find(input = { method: nil, uri: nil, header: nil, body: nil })
      input = input.compact.map { |k, v| [k.to_s, v] }.to_h
      rules.find do |rule|
        rule.trigger.all? do |k, v|
          input.dig(k) && input.dig(k).match?(v)
        end
      end
    end

    def rules
      @rules ||= Dir.glob(File.expand_path("rules/**/*.yml", __dir__)).map do |path|
        begin
          Rule.new path
        rescue InvalidRuleError => e
          puts "InvalidRurleError is raised when parsing #{path}"
        end
      end
    end
  end

  class Rule
    def initialize(path)
      @yaml = YAML.load_file path
      raise InvalidRuleError unless valid?
    end

    def id
      @id ||= @yaml.dig("meta", "id")
    end

    def note
      @note ||= @yaml.dig("meta", "note")
    end

    def enable?
      @enable ||= @yaml.dig("meta", "enable")
    end

    def trigger
      @trigger ||= @yaml.dig("trigger")
    end

    def response
      @response ||= @yaml.dig("response")
    end

    def valid?
      [id, note, enable?, trigger, response].all?
    end
  end
end
