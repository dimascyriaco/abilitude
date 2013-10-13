Abilitude
=========

Abilitude ia a library/DSL that enables you to create flexible Character classes that can be expanded with custom behavior.

A basic character class could be like:

    class Character
      include Abilitude::Character

      attr_accessor :strength

      def initialize(strength)
        @strength = strength
      end
    end


Abilities
---------

With that you can add abilities to the Character class:

    Character.ability :range do
      strength * 2
    end

Any character instances now have an 'range' method:

    char = Character.new(10)
    char.range # => 20


Traits
------

A Trait is a way to add behaviour to a character.

A trait class has to implement a **#apply_to** method that will receive the character. Here is a basic trait:

    class WeaknessTrait
      def apply_to(character)
        character.change :strength, -2
      end
    end

    char.add_trait(WeaknessTrait.new)
    char.strength # => 8


Modifiers
---------

A Trait can also add an modifier to the character. This modifier will change the value of a given ability.

A Modifier class have to implement **#target** and **#apply**.

    # This is a Modifier
    class ThrowBoost
      def target
        'range'
      end

      def apply(value)
        value * 10
      end
    end

    # This is a Trait
    class OlympicThrowerTrait
      def apply_to(character)
        character.add_modifier(ThrowBoost.new)
      end
    end

    char = Character.new(10)
    char.add_trait(OlympicThrowerTrait.new)
    char.range # => 200


You can add any number of modifiers for each ability:

    class SumModifier
      attr_reader :target, :value

      def initialize(target, value)
        @target = target
        @value  = value
      end

      def apply(character_value)
        character_value + value
      end
    end

    character = Character.new(10)
    character.range # => 20
    character.add_modifier(SumModifier.new('range', 2))
    character.add_modifier(SumModifier.new('range', 4))
    character.range # => 26

A Trait can also add and ability to a Character:

    class ChuckNorrisTrait
      def apply_to(character)
        character.add_ability(:round_house_kick) do
          strength * 10
        end
      end
    end

    character = Character.new(10)
    character.add_trait(ChuckNorrisTrait.new)
    character.round_house_kick # => 100

More coming soon.