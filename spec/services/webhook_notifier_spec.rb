require "rails_helper"

describe WebhookNotifier do
  describe "#send_notification" do
    context "when given a pull request with channels" do
      it "sends a post to each of the webhook url" do
        webhook_url = "http://example.com/webhook"
        allow(ENV).to receive(:fetch).
          with("SLACK_POST_WEBHOOK_URL").
          and_return(webhook_url)
        channels = [
          build_stubbed(:channel, name: "channel_1"),
          build_stubbed(:channel, name: "channel_2"),
        ]
        request_stubs = [
          stub_request(:post, webhook_url).with(body: /"channel":"channel_1"/),
          stub_request(:post, webhook_url).with(body: /"channel":"channel_2"/),
        ]

        pull_request = double(:pull_request, channels: channels).as_null_object

        notifier = WebhookNotifier.new(pull_request)
        notifier.send_notification

        request_stubs.each do |request_stub|
          expect(request_stub).to have_been_requested
        end
      end
    end
  end

  describe "#body" do
    it "is a description of the PR" do
      pull_request = double(
        :pull_request,
        github_url: "https://github.com/thoughtbot/pr-tool/pulls/1",
        repo_name: "thoughtbot/pr-tool",
        title: "Add Slack Integration",
        tag_names: ["code", "rails"],
        webhook_urls: [],
        additions: 20,
        deletions: 2,
      )
      channel = build_stubbed(:channel)

      notifier = WebhookNotifier.new(pull_request)

      expect(JSON.parse(notifier.body(channel))["text"]).to eq(
        "@PR thoughtbot/pr-tool (#code, #rails) (+20, -2) - <https://github.com/thoughtbot/pr-tool/pulls/1|Add Slack Integration>"
      )
    end

    it "includes the channel name" do
      pull_request = double(:pull_request).as_null_object
      channel = build_stubbed(:channel, name: "my_channel")

      notifier = WebhookNotifier.new(pull_request)
      body = JSON.parse(notifier.body(channel))

      expect(body["channel"]).to eq("my_channel")
    end
  end
end
