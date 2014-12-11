class MarkPrInProgress
  def initialize(parser)
    @parser = parser
  end

  def self.matches(parser)
    parser.event_type == "pull_request_review_comment"
  end

  def call
    pull_request = PullRequest.find_by(github_issue_id: parser.github_issue_id)
    pull_request.update(status: "in progress")
  end

  protected

  attr_reader :parser
end
