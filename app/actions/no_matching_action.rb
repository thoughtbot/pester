class NoMatchingAction
  def initialize(*)
  end

  def self.matches(*)
    true
  end

  def call
    # noop
  end
end
