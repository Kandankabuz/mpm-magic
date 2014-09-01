class Ability
  attr_accessor :name, :owner, :img, :description


  def initialize(owner)
    @owner = owner
  end

  def action
    nil
  end

  def permanent?
    true
  end

  def to_param
    "#{object_id}-#{name}"
  end

  def self.find(id)
    ObjectSpace._id2ref(id.to_i)
  end


  def play!
  end

  def card
    @owner
  end

end
