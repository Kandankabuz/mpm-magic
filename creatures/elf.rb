class Elf < Creature

  def initialize
    super
    @name =  "Forest Elf"
    @strength = 1
    @toughness = 1
    @type = "Elf"
    @cost = 1
    @img = "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQTt6OYHNJ99yDLLkpmgc1Nn_S0-fVBc7qTVK985y8KfT4RoIqD"
    add_ability(HealAbility.new)
  end

end
