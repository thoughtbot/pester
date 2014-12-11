require "rails_helper"

describe GithubPayloadsController do
  context "POST#create" do
    describe "for issue comments" do
      describe "when the comment has 'LGTM'" do
        it "completes the pull request" do
          create(:pull_request, github_issue_id: 123, status: "in progress")
          send_issue_comment(body: "This LGTM :poop:", github_issue_id: 123)
          expect(last_pull_request.status).to eq("completed")
        end
      end

      describe "when the comment does not contain 'LGTM'" do
        it "does not modify the pull request" do
          create(:pull_request, github_issue_id: 234, status: "in progress")
          send_issue_comment(body: "This is :poop:", github_issue_id: 234)
          expect(last_pull_request.status).to eq("in progress")
        end
      end
    end

    describe "when the action is 'opened'" do
      it "creates a new PullRequest" do
        send_pull_request_payload(action: "opened")
        expect(last_pull_request.status).to eq("needs review")
      end
    end

    describe "when the action is 'created'" do
      it "it updates the PullRequest's status to 'in progress'" do
        pr = create(:pull_request)
        send_pull_request_review_payload(
          github_issue_id: pr.github_issue_id
        )
        expect(last_pull_request.status).to eq("in progress")
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

  def send_pull_request_review_payload(github_issue_id:)
    request.headers["X-Github-Event"] = "pull_request_review_comment"
    post :create, payload: pull_request_review_comment_payload(github_issue_id: github_issue_id)
  end

  def send_issue_comment(body:, github_issue_id:)
    request.headers["X-Github-Event"] = "issue_comment"
    post :create, payload: issue_comment_payload(body: body, github_issue_id: github_issue_id)
  end

  def last_pull_request
    PullRequest.last
  end
end
