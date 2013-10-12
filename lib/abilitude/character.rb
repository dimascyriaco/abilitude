module Abilitude
  module Character
    module ClassMethods
      attr_reader :attributes

      # @param [Symbol] name
      # @param [Symbol] aliaz
      # @param [Calculator, #strategy, #calculate] calculator
      # @param [Proc] block
      def attribute(name, aliaz = nil, &block)
        @attributes ||= {}
        # @attributes << Attribute.new(&block)
        # @attributes << calculator.strategy(&block)
        @attributes[name] = block
        @attributes[aliaz] = block if aliaz
      end

      def has_attribute?(name)
        attributes.keys.include? name
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def method_missing(name, args = nil)
      if self.class.has_attribute?(name)
        self.instance_eval(&self.class.attributes[name])
      end
    end
  end
end