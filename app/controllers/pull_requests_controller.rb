class PullRequestsController < ApplicationController
  helper_method :pull_requests

  private

  def pull_requests
    @pull_requests ||= PullRequest.all
  end
end
