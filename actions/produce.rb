require_relative 'action'
class Produce < Action

  def initialize
    @name = "Produce"
    @img ="produce.png"
    @description ="Produce mana"
    @priority =1
  end

  def actionnable?
    super && card.in_play? &&  !card.tapped?
  end

  def execute!
    card.produce!
  end


end
