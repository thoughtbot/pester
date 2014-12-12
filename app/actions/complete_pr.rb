class CompletePr
  def initialize(parser, pull_request)
    @parser = parser
    @pull_request = pull_request
  end

  def self.matches(parser, _pull_request)
    parser.event_type == "issue_comment" &&
      parser.comment["body"] =~ /LGTM/
  end

  def call
    pull_request.update(status: "completed")
  end

  protected

  attr_reader :parser, :pull_request
end
