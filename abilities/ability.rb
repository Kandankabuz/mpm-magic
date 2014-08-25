require_relative 'summoning_sickness'
class Ability
  attr_accessor :name, :owner, :img, :description

  def action
    nil
  end

  def passive?
    true
  end

  def permanent?
    true
  end

  def activable?
    !passive? && @owner.in_play? && !(@owner.has_ability?(SummoningSickness))
  end

  def activate!
    @owner.tap!
  end

  def play!
  end

  def to_param
    "#{object_id}-#{name}"
  end

  def self.find(id)
    ObjectSpace._id2ref(id.to_i)
  end


end
