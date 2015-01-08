require "rails_helper"

describe PullRequestReposter do
  describe ".run" do
    it "reposts the given PRs to Slack" do
      prs_to_review = build_pair(:pull_request)
      notifier = double(:webhook_notifier)
      allow(WebhookNotifier).to receive(:new).and_return(notifier)
      allow(notifier).to receive(:send_notification)

      PullRequestReposter.run(prs_to_review)

      expect(notifier).to have_received(:send_notification).twice
    end

    it "sets the timestamp for when the review was reposted" do
      pr_to_review = create(:pull_request, reposted_at: nil)

      PullRequestReposter.run([pr_to_review])

      expect(pr_to_review.reload).to be_reposted
    end
  end
end
