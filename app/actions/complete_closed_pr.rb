class CompleteClosedPr
  def initialize(parser, pull_request)
    @parser = parser
    @pull_request = pull_request
  end

  def self.matches(parser, _pull_request)
    parser.action == "closed"
  end

  def call
    pull_request.update(status: "completed")
  end

  protected

  attr_reader :parser, :pull_request
end
