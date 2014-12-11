class CreateNewPr
  def initialize(parser)
    @parser = parser
  end

  def self.matches(parser)
    parser.action == "opened"
  end

  def call
    PullRequest.create(parser.params)
  end

  protected

  attr_reader :parser
end
