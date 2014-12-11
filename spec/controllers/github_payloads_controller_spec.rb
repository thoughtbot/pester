require "rails_helper"

describe GithubPayloadsController do
  context "POST#create" do
    describe "when the action is 'opened'" do
      it "creates a new PullRequest" do
        send_pull_request_payload(action: "opened")
        expect(last_pull_request.status).to eq("needs review")
      end

      it "creates a new Repo" do
        send_pull_request_payload(action: "opened")
        expect(last_pull_request.repo.full_name).to eq("baxterthehacker/public-repo")
      end

      it "attaches to an existing repo if one exists" do
        repo = create(
          :repo,
          full_name: "baxterthehacker/public-repo",
          github_url: "https://github.com/baxterthehacker/public-repo",
        )
        send_pull_request_payload(action: "opened")
        expect(last_pull_request.repo_id).to eq(repo.id)
      end
    end

    describe "when the action is not 'opened'" do
      it "does not create a pull request" do
        send_pull_request_payload(action: "merged")
        expect(last_pull_request).to be_nil
      end
    end
  end

  def send_pull_request_payload(action:)
    post :create, payload: pull_request_payload(action: action)
  end

  def last_pull_request
    PullRequest.last
  end
end
