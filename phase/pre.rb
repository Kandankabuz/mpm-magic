class Pre < Phase

  def initialize(options={})
    @name = "Pre combat"
    @action = "play"
  end

  def execute
  end

  def auto
    false
  end

end
