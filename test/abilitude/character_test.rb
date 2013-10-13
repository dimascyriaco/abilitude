require_relative '../test_helper'

class Character
  include Abilitude::Character
  attr_accessor :strength

  def initialize
    @strength = 10
  end
end

describe Abilitude::Character do
  before { @character = Character.new }

  describe ".attribute" do
    it 'Allows the addition of an attribute to the Character class' do
      Character.attribute :push_ups do
        strength * 2
      end

      @character.push_ups.must_equal 20
    end
  end

  describe "#change" do
    it 'Allows a modifier to change the value of a basic attribute' do
      @character.change(:strength, -2)
      @character.strength.must_equal(8)
    end

    it "Doesn't break if the attribute changed does not exists" do
      @character.change(:speed, -2)
    end
  end

  describe "#add_modifier" do
    it 'Allows modifiers to be added to the Character instance' do
      modifier = Struct.new('Modifier', :target).new('bla')
      @character.add_modifiers(modifier)
      @character.modifiers.must_equal(bla: [modifier])
    end
  end
end