require "ostruct"
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
        rescue InvalidRuleError => _
          puts "InvalidRuleError is raised when parsing #{path}"
        end
      end
    end
  end

  class Rule < OpenStruct

    def initialize(path)
      yaml = YAML.load_file(path)
      super yaml
      raise InvalidRuleError unless valid?
    end

    def id
      @id ||= meta.dig("id")
    end

    def note
      @note ||= meta.dig("note")
    end

    def enable?
      @enable ||= meta.dig("enable")
    end

    def valid?
      has_meta? && has_trigger? && has_response?
    end

    def has_response?
      ["status", "body"].all? { |key| response.key? key }
    end

    def has_trigger?
      ["method", "header", "uri", "body"].any? { |key| trigger.key? key }
    end

    def has_meta?
      [id, note, enable?].all? { |e| !e.nil? }
    end
  end
end
