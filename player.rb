require_relative 'deck'
require_relative 'hand'
require_relative 'actions/play'
require_relative 'lands/land'
require_relative 'graveyard'
require_relative 'mana_pool'
require_relative 'abilities/summoning_sickness'

class Player
  attr_accessor :name, :health , :permanents, :deck, :hand, :graveyard, :mana_pool, :flags

  DEFAULTS = {
     name:  "Player",
     health: 20,
  }

  def initialize(options={})
    options = DEFAULTS.merge(options)
    options.each {|k,v| send("#{k}=",v)}
    @permanents = []
    @deck = Deck.new
    @hand = Hand.new
    @graveyard =  Graveyard.new
    @mana_pool =  ManaPool.new(self)
    @flags =  {}
  end

  def alive?
    health > 0
  end

  def dead?
    !alive?
  end

  def cards_in_play
    @permanents
  end

  def attack!(player)
    Battle.new(self, player)
  end


  def draw!
    raise 'No More Card to Draw'   if deck.size ==0
    card = deck.draw!
    card.owner = self
    hand << card
  end

  def play!(card)
    hand.cards.delete card
    permanents << card
    card.owner = self
    card.play!
  end


  def unkeep!
    @flags = {}
    @mana_pool.reset!
  end

  def discard!(card)
    hand.cards.delete card
    graveyard << card
  end

  def clean!
    clean_dead_permanents!
    @permanents.each do |c|
      c.reset!
    end
  end

  def clean_dead_permanents!
    dead_permanents = []
    @permanents.each do |c|
      dead_permanents << c if c.dead?
    end
    @permanents -=  dead_permanents
  end

  def lands
    permanents.select do |card| card.is_a? Land end
  end


  def creatures
    permanents.select do |card| card.is_a? Creature end
  end


  def attack_all!
    creatures.select { |c| c.can? Attack}.each do |creature|
      creature.execute! Attack
    end
  end

  def auto_play!
    land = $world.current_player.hand.cards.find {|c| c.is_a?(Land) && c.can?(Play) }
    return land.execute!(Play) if land

    creature = $world.current_player.hand.cards.sort_by(&:cost).reverse.find {|c| c.is_a?(Creature) && c.can?(Play) }
    return creature.execute!(Play) if creature

    if $world.turn.phase.is_a?(Combat) && $world.current_player.creatures.find { |c| c.can?(Attack) } != nil
      return $world.current_player.attack_all!
    end
    if $world.turn.phase.is_a?(DiscardPhase)
      return $world.current_player.hand.cards.sort_by(&:cost).reverse[0].execute! Discard
    end
    return $world.turn.next!
  end

end
