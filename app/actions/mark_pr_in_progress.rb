class MarkPrInProgress
  EXCLUDED_USERS = ['houndci']

  def initialize(parser, pull_request)
    @parser = parser
    @pull_request = pull_request
  end

  def self.matches(parser, _pull_request)
    parser.event_type =~ /.*_comment$/ &&
      EXCLUDED_USERS.exclude?(parser.comment_user_login)
  end

  def call
    pull_request.update(status: "in progress")
  end

  protected

  attr_reader :parser, :pull_request
end
