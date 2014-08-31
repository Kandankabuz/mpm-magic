class Player
  attr_accessor :name, :health , :permanents, :deck, :hand, :graveyard, :mana_pool, :flags, :played

  DEFAULTS = {
     name:  "Player",
     health: 20,
  }

  def initialize(options={})
    options = DEFAULTS.merge(options)
    options.each {|k,v| send("#{k}=",v)}
    @permanents = []
    @deck = []
    @hand = []
    @graveyard = []
    @mana_pool =  ManaPool.new(self)
    @played =  false
    @flags =  {}
  end

  def alive?
    health > 0
  end

  def played?
    played
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
    hand << deck.shift
  end

  def play!(card)
    hand.delete card
    permanents << card
    card.play!
  end


  def add_permanent!(card)
    permanents << card
    card.owner = self
  end


  def unkeep!
    @flags = {}
    @mana_pool.reset!
  end

  def discard!(card)
    hand.delete card
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



  def setup!
    20.times do
      deck << Mountain.new(self)
      deck << Forest.new(self)
      # deck << Gob.new
    end


    40.times do
      deck << Creature.all.shuffle[0].new(self)
      # deck << Dragon.new
    end

    deck.shuffle!
    hand << Nightmare.new(self)
    6.times { draw! }

  end
  #
  # def setup!
  #   20.times do
  #     deck << Mountain.new(self)
  #     deck << Forest.new(self)
  #     # deck << Gob.new
  #   end
  #
  #
  #   40.times do
  #     deck << Creature.all.shuffle[0].new(self)
  #     # deck << Dragon.new
  #   end
  #
  #   deck.shuffle!
  #
  #   7.times { draw! }
  #
  # end

  def playing?
    self == $world.playing_player
  end

  def opponent
    $world.p1 == self ? $world.p2 : $world.p1
  end

  def auto_play!
    return "" if !playing?
    land = hand.find {|c| c.is_a?(Land) && c.can?(Play) }
    return land.execute!(Play) if land

    creature = hand.sort_by(&:cost).reverse.find {|c| c.is_a?(Creature) && c.can?(Play) }
    return creature.execute!(Play) if creature

    if $world.turn.phase.is_a?(Combat) && creatures.find { |c| c.can?(Attack) } != nil
      return attack_all!
    end

    if $world.turn.phase.is_a?(DiscardPhase)
      return hand.sort_by(&:cost).reverse[0].execute! Discard
    end
    return $world.turn.next!
  end

  def to_param
    "#{object_id}-#{name}"
  end

  def self.find(id)
    ObjectSpace._id2ref(id.to_i)
  end


end
