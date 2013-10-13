module Abilitude
  module Character
    module ClassMethods
      attr_reader :attributes

      # Add a dynamic attribute to the Class
      #
      # The block passed will we evaluated in the context
      # of an instance of the Class
      #
      # @example
      #
      # class Character
      #   include Abilitude::Character
      #   attr_reader :strength
      #
      #   def initialize(strength)
      #     @strength = strength
      #   end
      #
      #   attribute :lift do
      #     strength * 10
      #   end
      # end
      #
      # Character.attribute :push_ups do
      #   strength * 2
      # end
      #
      # character = Character.new(10)
      #
      # character.lift      # => 100
      # character.push_ups  # => 20
      #
      # @param [Symbol] name
      # @param [Symbol] aliaz
      # @param [Calculator, #strategy, #calculate] calculator
      # @param [Proc] block
      def attribute(name, aliaz = nil, &block)
        @attributes ||= {}
        @attributes[name] = block
        @attributes[aliaz] = block if aliaz
      end

      # @param [Symbol, String] name
      # @return [Boolean]
      def has_attribute?(name)
        return false unless attributes

        attributes.keys.include? name.to_sym
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    attr_accessor :modifiers

    def add_trait(trait)
      traits = Array(trait)

      traits.each do |trait|
        trait.apply_to(self)
      end
    end

    def change(attribute, amount)
      current = send(attribute)
      return unless current

      send("#{attribute}=", current + amount)
    end

    def add_modifiers(new_modifiers)
      self.modifiers ||= Hash.new([])
      new_modifiers = Array(new_modifiers)

      new_modifiers.each do |mod|
        self.modifiers[mod.target.to_sym] += [mod]
      end
    end

    def add_modifier(new_modifier)
      add_modifiers(new_modifier)
    end

    def add_abilities(ability_name, &block)
      self.class.attribute ability_name, &block
    end

    def method_missing(name, args = nil)
      if self.class.has_attribute?(name)
        calculate_attribute(name)
      else
        super(name, args)
      end
    end

    def calculate_attribute(name)
      self.modifiers ||= Hash.new([])

      value = self.instance_eval(&self.class.attributes[name])

      self.modifiers[name.to_sym].each do |mod|
        value = mod.apply(value)
      end

      value
    end
  end
end