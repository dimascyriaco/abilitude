Abilitude
=========

Abilitude ia a library/DSL that enables you to create flexible Character classes that can be expanded with custom behavior.

The basic concept is Abilitude is that an Character has a set of basic attributes (normal Ruby instance variables) and zero or more
'abilities'. An ability is nothing more than a secondary attribute, calculated on top of a basic attribute. The value of an ability can
be modified by Modifiers. The least concept is of the Trait, which is a 'package' of Abilities and Modifiers that can be
added to a Character all at once. A Trait can be used to create an 'Advantage' system or a 'Class' system. Let's see some examples.

A basic Character
----------------

A basic character class (that has only a 'strength' basic attribute) could be like:

    class Character
      include Abilitude::Character

      attr_accessor :strength

      def initialize(strength)
        @strength = strength
      end
    end

You only have to mixin Abilitude here. Nothing else is required.


Adding an Ability
----------------

With that you can add abilities to the Character class:

    Character.ability :range do
      strength * 2
    end

Note that you can add an ability inside the class itself:

    class Character
      # ...

      ability :range do
        strength * 2
      end
    end

Any character instances now have an 'range' method:

    char = Character.new(10)   # strength = 10
    char.range # => 20           range = 20


Using Traits to modify Characters
---------------------------------

There is three ways in which a Trait can modify a Character. It can **#change** a basic attribute, **#add_ability** or **#add_modifier**.
A Trait can be any class that implements **#apply_to**. Apply_to will receive the character, on which the trait could
 call #change, #add_ability or #add_modifier.

Using a Trait to change a basic attribute
----------------------------------------

A Trait can modify a basic attribute:

    class WeaknessTrait
      def apply_to(character)
        character.change :strength, -2
      end
    end

    char.add_trait(WeaknessTrait.new)
    char.strength # => 8


Using Traits to add Modifiers to an Ability
---------

A Trait can also add an modifier to the character. This modifier will change the value of a given ability.

A Modifier is any class that implement **#target** and **#apply**. Target is the ability to be modified and #apply will
receive the value of that ability and must return the modified value.

    # Given the Character class above with an 'range' ability

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

Using a Trait to add an Ability to a Character
----------------------------------------------

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