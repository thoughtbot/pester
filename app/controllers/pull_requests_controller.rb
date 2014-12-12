class PullRequestsController < ApplicationController
  helper_method :pull_requests, :tags, :tags_to_filter_by

  private

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
