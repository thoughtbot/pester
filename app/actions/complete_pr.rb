class CompletePr
  def initialize(parser)
    @parser = parser
  end

  def self.matches(parser)
    parser.event_type == "issue_comment" &&
      parser.comment["body"] =~ /LGTM/
  end

  def call
    pull_request = PullRequest.find_by(github_issue_id: parser.github_issue_id)
    pull_request.update(status: "completed")
  end

  protected

  attr_reader :parser
end
