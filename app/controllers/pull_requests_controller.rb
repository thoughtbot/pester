class PullRequestsController < ApplicationController
  helper_method :grouped_pull_requests, :tags, :tags_to_filter_by

  def show
    @pull_request = PullRequest.find(params[:id])
  end

  private

  def grouped_pull_requests
    pull_requests.group_by(&:status)
  end

  def pull_requests
    @pull_requests ||= PullRequest.for_tags(tags_to_filter_by).active
  end

  def tags
    @tags ||= Tag.with_active_pull_requests
  end

  def tags_to_filter_by
    params.fetch(:tags, "").split(",")
  end
end
