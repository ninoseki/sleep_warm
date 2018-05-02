require "ostruct"
require "yaml"

module SleepWarm
  class MRR
    def find(input = { method: nil, uri: nil, header: nil, body: nil })
      input = input.compact.map { |k, v| [k.to_s, v] }.to_h
      matched = valid_rules.select do |rule|
        rule.trigger.all? do |k, v|
          input.dig(k) && input.dig(k).match?(v)
        end
      end
      # if there are multiple muthecd rules, return the last one.
      matched.empty? ? nil : matched.last
    end

    def rules
      @rules ||= Dir.glob(File.expand_path("rules/**/*.yml", __dir__)).map do |path|
        Rule.new path
      end
    end

    def valid_rules
      rules.select { |rule| rule.valid? && rule.enable? }.sort_by(&:id)
    end

    def invalid_rules
      rules.reject(&:valid?)
    end
  end

  class Rule

    attr_reader :path
    attr_reader :attributes

    def initialize(path)
      @path = path
      @attributes = YAML.load_file(path)
    end

    def id
      @id ||= attributes.dig("meta", "id")
    end

    def note
      @note ||= attributes.dig("meta", "note")
    end

    def enable?
      @enable ||= attributes.dig("meta", "enable")
    end

    def trigger
      @trigger ||= attributes.dig("trigger")
    end

    def response
      @response ||= attributes.dig("response")
    end

    def valid?
      return false unless attributes.is_a? Hash
      begin
        has_meta? && has_trigger? && has_response?
      rescue NoMethodError
        false
      end
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
