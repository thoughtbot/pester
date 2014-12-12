class CreateNewPr
  def initialize(parser, _pull_request)
    @parser = parser
  end

  def self.matches(parser, _pull_request)
    parser.action == "opened"
  end

  def call
    PullRequest.create(parser.params)
  end

  protected

  attr_reader :parser
end
