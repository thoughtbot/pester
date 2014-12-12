class PullRequestsController < ApplicationController
  helper_method :pull_requests, :tags

  private

  def pull_requests
    @pull_requests ||= PullRequest.active.includes(:tags)
  end

  def tags
    @tags ||= pull_requests.flat_map(&:tags).uniq
  end
end
