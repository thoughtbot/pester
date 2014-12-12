require "rails_helper"

describe GithubPayloadsController do
  context "POST#create" do
    describe "when the action is 'opened'" do
      it "creates a new PullRequest" do
        send_pull_request_payload(action: "opened")
        expect(last_pull_request.status).to eq("needs review")
      end
    end

    describe "when the action is 'created'" do
      it "updates the PullRequest's status to 'in progress'" do
        pr = create(:pull_request)
        send_pull_request_review_payload(
          github_issue_id: pr.github_issue_id
        )
        expect(last_pull_request.status).to eq("in progress")
      end

      context "when the comment is from Hound" do
        it "does not mark the PR as 'in progress" do
          pr = create(:pull_request)
          send_pull_request_review_payload(
            github_issue_id: pr.github_issue_id,
            comment_user: "hound"
          )
          expect(last_pull_request.status).to eq("needs review")
        end
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

  def send_pull_request_review_payload(github_issue_id:, comment_user: "mr_t")
    request.headers["X-Github-Event"] = "pull_request_review_comment"
    post :create, payload: pull_request_review_comment_payload(
      github_issue_id: github_issue_id,
      comment_user: comment_user
    )
  end

  def last_pull_request
    PullRequest.last
  end
end
