class MarkPrNeedsReview
  def initialize(parser)
    @parser = parser
  end

  def self.matches(parser)
    parser.event_type == "pull_request_review_comment" &&
    parser.needs_re_review?
  end

  def call
    pull_request = PullRequest.find_by(github_issue_id: parser.github_issue_id)
    pull_request.update(status: "needs review")
  end

  protected

  attr_reader :parser
end
