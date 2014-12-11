class GithubPayloadsController < ApplicationController
  def create
    if pr_is_new?
      PullRequest.create(pr_params)
    end

    render nothing: true
  end

  private

  def pr_is_new?
    parser.action == "opened"
  end

  def parser
    @_parser ||= PayloadParser.new(params[:payload])
  end

  def pr_params
    parser.params
  end
end
