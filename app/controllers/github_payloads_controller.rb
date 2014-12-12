class GithubPayloadsController < ApplicationController
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
    [CreateNewPr, MarkPrInProgress, CompletePr, CompleteClosedPr, NoMatchingAction]
  end

  def parser
    @_parser ||= PayloadParser.new(params[:github_payload], request.headers)
  end

  def pr_params
    parser.params
  end

  def pull_request
    PullRequest.find_by(github_issue_id: parser.github_issue_id)
  end
end
