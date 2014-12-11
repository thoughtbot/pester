class GithubPayloadsController < ApplicationController
  def create
    action_matching(parser).call

    render nothing: true
  end

  private

  def action_matching(*args)
    actions
      .find { |action| action.matches(*args) }
      .new(*args)
  end

  def actions
    [CreateNewPr, MarkPrInProgress, NoMatchingAction]
  end

  def parser
    @_parser ||= PayloadParser.new(params[:payload], request.headers)
  end

  def pr_params
    parser.params
  end
end
