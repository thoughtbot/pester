class PullRequestReposter
  def initialize(pull_requests)
    @pull_requests = pull_requests
  end

  def self.run(pull_requests)
    self.new(pull_requests).run
  end

  def run
    pull_requests.each do |pull_request|
      post_to_slack(pull_request)
      mark_as_reposted(pull_request)
    end
  end

  private

  attr_reader :pull_requests

  def post_to_slack(pull_request)
    WebhookNotifier.new(pull_request).send_notification
  end

  def mark_as_reposted(pull_request)
    pull_request.update(reposted: true)
  end
end
