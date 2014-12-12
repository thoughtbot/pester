class MarkPrInProgress
  def initialize(parser, pull_request)
    @parser = parser
    @pull_request = pull_request
  end

  def self.matches(parser, _pull_request)
    parser.event_type == "pull_request_review_comment" &&
    !parser.needs_re_review?
  end

  def call
    pull_request.update(status: "in progress")
  end

  protected

  attr_reader :parser, :pull_request
end
