require "rails_helper"

describe Triggers::SlackController do
  describe "POST#create" do
    pending "verifies the team domain is thoughtbot" do
      params = slash_command_payload(team_domain: "Lullabot")

      post :create, params

      expect(response).to be_forbidden
    end

    pending "verifies the team id is thoughtbot's" do
      allow(ENV).to receive(:fetch).with(:slack_team_id).and_return("abc123")
      params = slash_command_payload(team_id: "incorrect_team_id")

      post :create, params

      expect(response).to be_forbidden
    end

    pending "verifies the correct webhook token" do
      allow(ENV).to receive(:fetch).
        with(:slack_webhook_token).
        and_return("abc123")
      params = slash_command_payload(token: "incorrect_token")

      post :create, params

      expect(response).to be_forbidden
    end

    pending "only responds to the '/beg' command" do
      params = slash_command_payload(command: "/foobar")

      post :create, params

      expect(response).to be_forbidden
    end

    pending "checks for a valid github link" do
      params = slash_command_payload(text: "link not present")

      post :create, params

      expect(response.body).to eq(t("trigger.slack.missing_pr_link"))
    end

    pending "warns if the project does not have beggar set up" do
      pull_request_url = "https://github.com/thoughtbot/beggar/pull/82"
      params = slash_command_payload(text: pull_request_url)

      post :create, params

      expect(response.body).to eq(t("trigger.slack.webhook_not_configured"))
    end

    context "with a valid github PR link" do
      context "when the PR is closed" do
        pending "warns the user and does not start begging" do
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          stub_pr_status_api_response(pull_request_url, :closed)
          params = slash_command_payload(text: pull_request_url)

          expect { post :create, params }.not_to change(PullRequest, :count)

          expect(response.body).to eq(t("trigger.slack.pull_request_closed"))
        end
      end

      context "when the PR is open" do
        pending "creates a PullRequest with status 'needs review'" do
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          stub_pr_status_api_response(pull_request_url, :open)
          params = slash_command_payload(text: pull_request_url)

          post :create, params

          created_pr = PullRequest.last
          expect(created_pr.github_url).to eq(pull_request_url)
          expect(created_pr.status).to eq(pull_request_url)
        end

        pending "responds with a success message" do
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          stub_pr_status_api_response(pull_request_url, :open)
          params = slash_command_payload(text: pull_request_url)

          post :create, params

          expect(response.body).to eq(t("trigger.slack.success"))
        end
      end

      context "when the channel exists" do
        pending "uses the existing channel to beg on" do
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          channel = create(:channel)
          stub_pr_status_api_response(pull_request_url, :open)
          params = slash_command_payload(
            text: pull_request_url,
            channel: channel.name,
          )

          post :create, params

          pull_request = PullRequest.last
          expect(pull_request.channel).to eq(channel)
        end
      end

      context "when the channel does not exist" do
        it "creates a new record to match the channel name from the request"

        pending "STOPGAP warns the user and does not create the PR" do
          project = create(:project)
          pull_request_url = project.github_url + "/pull/82"
          stub_pr_status_api_response(pull_request_url, :open)
          params = slash_command_payload(
            text: pull_request_url,
            channel: "foobar",
          )

          post :create, params

          expect(response.body).to eq(t("trigger.slack.invalid_channel"))
        end
      end
    end
  end

  def slash_command_payload(options)
    {
      token: "JrYJkSSvJB68Wmh4KDSBnEL4",
      team_id: "T024HFHU3",
      team_domain: "thoughtbot",
      channel_id: "C0415Q26Q",
      channel_name: "beggar-test",
      user_id: "U02UQMU1P",
      user_name: "grayson",
      command: "/beg",
      text: "https://github.com/thoughtbot/beggar/82",
    }.merge(options)
  end
end
