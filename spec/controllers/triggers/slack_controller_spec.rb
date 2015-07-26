require "rails_helper"

describe Triggers::SlackController do
  describe "POST#create" do
    it "verifies the team domain is thoughtbot" do
      allow(ENV).to receive(:fetch)
      allow(ENV).to receive(:fetch).
        with("SLACK_TEAM_DOMAIN").
        and_return("thoughtbot")
      params = slash_command_payload(team_domain: "Lullabot")

      post :create, params

      expect(response.status).to eq 403
    end

    it "verifies the team id is thoughtbot's" do
      allow(ENV).to receive(:fetch)
      allow(ENV).to receive(:fetch).with("SLACK_TEAM_ID").and_return("abc123")
      params = slash_command_payload(team_id: "incorrect_team_id")

      post :create, params

      expect(response.status).to eq 403
    end

    it "verifies the correct webhook token" do
      allow(ENV).to receive(:fetch)
      allow(ENV).to receive(:fetch).
        with("SLACK_WEBHOOK_TOKEN").
        and_return("abc123")
      params = slash_command_payload(token: "incorrect_token")

      post :create, params

      expect(response.status).to eq 403
    end

    it "only responds to the '/beg' command" do
      params = slash_command_payload(command: "/foobar")

      post :create, params

      expect(response.status).to eq 403
    end

    it "checks for a valid github link" do
      params = slash_command_payload(text: "link not present")

      post :create, params

      expect(response.body).to eq(t("trigger.slack.missing_pr_link"))
    end

    it "warns if the project does not have beggar set up" do
      pull_request_url = "https://github.com/thoughtbot/beggar/pull/82"
      params = slash_command_payload(text: pull_request_url)

      post :create, params

      expect(response.body).to eq(t("trigger.slack.webhook_not_configured"))
    end

    context "with a valid github PR link" do
      context "when the PR is closed" do
        it "warns the user and does not start begging" do
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          stub_pr_status_api_response(pull_request_url, :closed)
          params = slash_command_payload(text: pull_request_url)

          expect { post :create, params }.not_to change(PullRequest, :count)

          expect(response.body).to eq(t("trigger.slack.pull_request_closed"))
        end
      end

      context "when the PR is open" do
        it "creates a PullRequest with status 'needs review'" do
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          stub_pr_status_api_response(pull_request_url, :open)
          params = slash_command_payload(text: pull_request_url)

          post :create, params

          created_pr = PullRequest.last
          expect(created_pr.github_url).to eq(pull_request_url)
          expect(created_pr.status).to eq("needs review")
        end

        it "responds with a success message" do
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          stub_pr_status_api_response(pull_request_url, :open)
          params = slash_command_payload(text: pull_request_url)

          post :create, params

          expect(response.body).to eq(t("trigger.slack.success"))
        end
      end

      context "when the channel exists" do
        it "uses the existing channel to beg on" do
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          channel = create(:channel)
          stub_pr_status_api_response(pull_request_url, :open)
          params = slash_command_payload(
            text: pull_request_url,
            channel_name: channel.name,
          )

          post :create, params

          pull_request = PullRequest.last
          expect(pull_request.channels).to eq([channel])
        end
      end

      context "when the channel does not exist" do
        it "creates a new record to match the channel name from the request" do
          channel_name = "foobar"
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          stub_pr_status_api_response(pull_request_url, :open)
          params = slash_command_payload(
            text: pull_request_url,
            channel_name: channel_name,
          )

          expect { post :create, params }.to change(Channel, :count).by(1)

          pull_request = PullRequest.last
          expect(pull_request.channels.map(&:name)).to eq([channel_name])
        end
      end
    end
  end

  def stub_pr_status_api_response(pull_request_url, status)
    allow(GithubApi).to receive(:pull_request_status).
      with(pull_request_url).
      and_return(status)
  end

  def slash_command_payload(options)
    {
      token: ENV.fetch("SLACK_WEBHOOK_TOKEN"),
      team_id: ENV.fetch("SLACK_TEAM_ID"),
      team_domain: ENV.fetch("SLACK_TEAM_DOMAIN"),
      channel_id: "C0415Q26Q",
      channel_name: "beggar-test",
      user_id: "U02UQMU1P",
      user_name: "grayson",
      command: "/beg",
      text: "https://github.com/thoughtbot/beggar/82",
    }.merge(options)
  end
end
