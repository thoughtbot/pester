class GithubPayloadsController < ApplicationController
  before_action VerifyGithubSignature.new(ENV["GITHUB_SECRET_KEY"])
  skip_before_action :ensure_team_member

  def create
    action_matching(parser, pull_request).call

    head :ok
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
    @_parser ||= PayloadParser.new(payload_params, request.headers)
  end

  def payload_params
    params[:github_payload].permit!
  end

  def pr_params
    parser.params
  end

  def pull_request
    PullRequest.find_by(github_url: parser.github_url) || NullPullRequest.new
  end
end
