class Play < Action

  def initialize(owner=nil)
    super(owner)
    @name = "Play"
    @img ="play.png"
    @description ="Play this card"
    @priority =1
  end

  def can_be_activated
    super && card.in_hand? &&
      ( world.turn.phase.is_a?(Pre) ||
        world.turn.phase.is_a?(Post) ||
        world.turn.phase.is_a?(DiscardPhase)  ) && card.can_be_played? && card.owner.playing?
  end

  def execute!
  super
    player.play! card
  end


end
