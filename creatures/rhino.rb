class Rhino < Creature

  def initialize
    super
    @name = 'Crash of Rhinos'
    @strength = 8
    @toughness = 4
    @type = "Creature"
    @cost = 8 # 6GG
    @description =  "Trample"
    @img = "http://1.bp.blogspot.com/-mhGnu-OL0OY/UFz18xU2EKI/AAAAAAAAAvU/CNIREPLerCs/s1600/rhino running.jpg"
    @mtg_id = 3379
  end

end
