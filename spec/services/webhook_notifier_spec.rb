require "rails_helper"

describe WebhookNotifier do
  describe "#send_notification" do
    context "when given a pull request with channels" do
      it "sends a post to each of the webhook url" do
        channel1 = build_stubbed(
          :channel,
          webhook_url: "http://example.com/webhook",
        )
        channel2 = build_stubbed(
          :channel,
          webhook_url: "https://example.com/webhook2",
        )

        pull_request = double(
          :pull_request,
          channels: [channel1, channel2]
        ).as_null_object

        request_stub = stub_request(
          :post, channel1.webhook_url
        ).with(body: /.*/)
        request_stub2 = stub_request(
          :post, channel2.webhook_url
        ).with(body: /.*/)

        notifier = WebhookNotifier.new(pull_request)
        notifier.send_notification

        expect(request_stub).to have_been_requested
        expect(request_stub2).to have_been_requested
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
