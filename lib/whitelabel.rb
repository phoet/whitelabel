require "whitelabel/version"

require "yaml"

module Whitelabel
  class << self
    attr_accessor :labels

    def from_file(path)
      @labels = File.open(path) { |file| YAML.load(file) }
    end

    def label
      Thread.current[:whitelabel]
    end

    def label=(label)
      Thread.current[:whitelabel] = label
    end

    def label_for(pattern, identifier=:label_id)
      self.label = find_label(pattern, identifier)
    end

    def find_label(pattern, identifier=:label_id)
      @labels.find { |label| label.send(identifier) =~ /^#{pattern}$/ }
    end

    def with_label(tmp=nil)
      if tmp
        current_label = self.label
        self.label = tmp
      end
      yield
    ensure
      self.label = current_label if current_label
    end

    def [](accessor)
      raise "set a label before calling '#{accessor}'" if self.label.nil?
      self.label.send :"#{accessor}"
    end

    def reset!
      Thread.current[:whitelabel] = nil
    end
  end
end
