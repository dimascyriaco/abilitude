require_relative '../test_helper'

class Character
  include Abilitude::Character
  attr_reader :strength

  def initialize
    @strength = 10
  end
end

describe Abilitude do
  it 'Allows the addition of an attribute to the Character class' do
    Character.attribute :push_ups do
      strength * 2
    end

    character = Character.new
    character.push_ups.must_equal 20
  end
end