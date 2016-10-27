class GithubPayloadsController < ApplicationController
  before_action VerifyGithubSignature.new(ENV["GITHUB_SECRET_KEY"])
  skip_before_filter :ensure_team_member

  def create
    action_matching(parser, pull_request).call

    render nothing: true
  end

  private

  def action_matching(*args)
    actions
      .find { |action| action.matches(*args) }
      .new(*args)
  end

  def actions
    [
      CreateNewPr,
      CompletePr,
      CompleteClosedPr,
      MarkPrNeedsReview,
      MarkPrInProgress,
      NoMatchingAction,
    ]
  end

  def parser
    @_parser ||= PayloadParser.new(params[:github_payload], request.headers)
  end

  def pr_params
    parser.params
  end

  def pull_request
    PullRequest.find_by(github_url: parser.github_url) || NullPullRequest.new
  end
end
