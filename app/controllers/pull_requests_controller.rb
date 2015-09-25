class PullRequestsController < ApplicationController
  helper_method :grouped_pull_requests, :tags, :tags_to_filter_by

  def index
    respond_to do |format|
      format.html
      format.json { render json: pull_requests }
    end
  end

  private

  def grouped_pull_requests
    pull_requests.group_by(&:status)
  end

  def pull_requests
    @pull_requests ||= PullRequest.for_tags(tags_to_filter_by).active
  end

  def tags
    @tags ||= Channel.with_active_pull_requests.flat_map(&:tags)
  end

  def tags_to_filter_by
    params.fetch(:tags, "").split(",")
  end
end
