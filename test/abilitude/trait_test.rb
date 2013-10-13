require_relative '../test_helper'

class Character
  include Abilitude::Character
  attr_accessor :strength, :intelligence

  def initialize
    @strength = 10
    @intelligence = 10
  end
end

class Modifier
  attr_reader :target

  def initialize(target)
    @target = target
  end

  def apply(value)
    value * 2
  end
end

class Trait
  def apply_to(character)
    character.change(:strength, -2)

    character.add_ability(:vision) do
      intelligence * 10
    end

    character.add_modifiers(Modifier.new(:vision))
  end
end

describe Abilitude do
  describe "#apply_to" do
    it 'changes an attribute' do
      character = Character.new
      character.add_trait(Trait.new)
      character.strength.must_equal 8
    end

    it 'add an ability' do
      character = Character.new
      character.add_trait(Trait.new)
      character.vision.must_equal 200
    end
  end

  describe "Modifier" do
    it 'modifies' do
      Character.ability :push_ups do
        strength
      end

      character = Character.new
      character.add_modifiers(Modifier.new(:push_ups))
      character.push_ups.must_equal(20)
    end
  end
end