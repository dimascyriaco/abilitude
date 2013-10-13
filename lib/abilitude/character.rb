module Abilitude
  module Character
    module ClassMethods
      attr_reader :abilities

      # Add a abilities to the Class
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
      #   ability :lift do
      #     strength * 10
      #   end
      # end
      #
      # Character.ability :push_ups do
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
      def ability(name, aliaz = nil, &block)
        @abilities ||= {}
        @abilities[name] = block
        @abilities[aliaz] = block if aliaz
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
      return false unless self.respond_to?(attribute)

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

    def add_ability(ability, &block)
      self.class.ability ability, &block
    end

    def respond_to?(name)
      return true if has_ability?(name)
      super(name)
    end

    private

    def has_ability?(name)
      return false unless self.class.abilities

      self.class.abilities.keys.include? name.to_sym
    end

    def calculate_ability(name)
      self.modifiers ||= Hash.new([])

      value = self.instance_eval(&self.class.abilities[name])

      self.modifiers[name.to_sym].each do |mod|
        value = mod.apply(value)
      end

      value
    end

    def method_missing(name, *args, &block)
      if has_ability?(name)
        calculate_ability(name)
      else
        super(name, *args, &block)
      end
    end
  end
end