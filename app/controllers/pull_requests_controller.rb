class PullRequestsController < ApplicationController
  helper_method :grouped_pull_requests, :tags, :tags_to_filter_by
  skip_before_filter :ensure_thoughtbot_team, only: :index

  def index
    respond_to do |format|
      format.html { ensure_thoughtbot_team }
      format.json { render json: pull_requests }
    end
  end

  private

  def grouped_pull_requests
    pull_requests.group_by(&:status)
  end

  def pull_requests
    @pull_requests ||= PullRequest.
      for_tags(tags_to_filter_by).
      active.
      uniq
  end

  def tags
    @tags ||= Tag.with_active_pull_requests
  end

  def tags_to_filter_by
    params.fetch(:tags, "").split(",")
  end
end
