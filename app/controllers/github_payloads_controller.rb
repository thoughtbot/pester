class GithubPayloadsController < ApplicationController
  def create
    if pr_is_new?
      repo = Repo.find_or_create_by!(pr_params.delete(:repo_params))
      repo.pull_requests.create!(pr_params)
    end

    render nothing: true
  end

  private

  def pr_is_new?
    parser.action == "opened"
  end

  def parser
    @_parser ||= PayloadParser.new(params[:payload], RepoPayloadParser.new)
  end

  def pr_params
    @pr_params ||= parser.params
  end
end
