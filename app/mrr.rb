require "ostruct"
require "yaml"

module SleepWarm
  class MRR
    # Returns a matched SleepWarm::Rule based on the input
    #
    # @param [Hash] input
    # @ptions input [String] :method HTTP method
    # @ptions input [String] :uri URI
    # @ptions input [String] :header HTTP header
    # @ptions input [String] :body HTTP body
    # @return [SleepWarm::Rule, nil] The matched rule or nil if there is no matched one.
    def find(input = { method: nil, uri: nil, header: nil, body: nil })
      input = input.compact.map { |k, v| [k.to_s, v] }.to_h
      matched = valid_rules.select do |rule|
        rule.trigger.all? do |k, v|
          input.dig(k)&.match?(v)
        end
      end
      # if there are multiple muthecd rules, return the last one.
      matched.empty? ? nil : matched.last
    end

    # Returns an Array of SleepWarm::Rule
    #
    # return [Array<SleepWarm::Rule>]
    def rules
      @rules ||= Dir.glob(File.expand_path("rules/**/*.yml", __dir__)).select do |path|
        path.match? /\d+.yml$/
      end.map do |path|
        Rule.new path
      end
    end

    # Returns an Array of SleepWarm::Rule which is valid
    #
    # return [Array<SleepWarm::Rule>]
    def valid_rules
      rules.select { |rule| rule.valid? && rule.enable? }.sort_by(&:id)
    end

    # Returns an Array of SleepWarm::Rule which is invalid
    #
    # return [Array<SleepWarm::Rule>]
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
      @trigger ||= attributes.dig("trigger") || {}
    end

    def response
      @response ||= attributes.dig("response") || {}
    end

    def valid?
      return false unless attributes.is_a? Hash
      begin
        meta? && trigger? && response?
      rescue NoMethodError
        false
      end
    end

    def response?
      ["status", "body"].all? { |key| response.key? key }
    end

    def trigger?
      ["method", "header", "uri", "body"].any? { |key| trigger.key? key }
    end

    def meta?
      [id, note, enable?].all?
    end
  end
end
