require 'spec_helper'
require 'services/webhook_notifier'
require 'json'
require 'net/http'

describe WebhookNotifier do
  describe '#send_notification' do
    context 'when given a pull request with webhook urls' do
      it 'sends a post to each of the webhook url' do
        url = 'http://www.example.com/webhook'
        url2 = 'https://www.example.com/webhook2'
        pull_request = double(:pull_request, webhook_urls: [url, url2]).as_null_object

        request_stub = stub_request(:post, url).with(body: /.*/)
        request_stub2 = stub_request(:post, url2).with(body: /.*/)

        notifier = WebhookNotifier.new(pull_request)
        notifier.send_notification

        expect(request_stub).to have_been_requested
        expect(request_stub2).to have_been_requested
      end
    end
  end

  describe '#body' do
    it 'is a description of the PR' do
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

      notifier = WebhookNotifier.new(pull_request)

      expect(JSON.parse(notifier.body)['text']).to eq(
        "@PR thoughtbot/pr-tool (#code, #rails) (+20, -2) - <https://github.com/thoughtbot/pr-tool/pulls/1|Add Slack Integration>"
      )
    end
  end
end
