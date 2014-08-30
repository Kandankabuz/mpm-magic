class TeferisImp < Creature

  def initialize
    super
    @name = 'Teferi's Imp'
    @strength = 1
    @toughness = 1
    @type = "Creature"
    @cost = 3 # 2U
    @description =  "Flying Phasing (This phases in or out before you untap during each of your untap steps. While it's phased out, it's treated as though it doesn't exist.) Whenever Teferi's Imp phases out, discard a card. Whenever Teferi's Imp phases in, draw a card."
    @img = "http://images1.wikia.nocookie.net/__cb20080618101518/sfery/images/8/8b/Imp02.jpg"
    @mtg_id = 3369
  end

end
