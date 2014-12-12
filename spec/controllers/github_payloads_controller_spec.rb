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

    describe "when the action is 'closed'" do
      it "moves the pull request to 'completed'" do
        create(:pull_request, github_issue_id: 123, status: "needs review")
        send_pull_request_payload(action: "closed", github_issue_id: 123)
        expect(last_pull_request.status).to eq("completed")
      end
    end

    describe "when the action is 'opened'" do
      it "creates a new PullRequest" do
        send_pull_request_payload(action: "opened")
        expect(last_pull_request.status).to eq("needs review")
      end

      it "does not error if the payload has no body" do
        expect {
          send_pull_request_payload(action: "opened", body: nil)
        }.not_to raise_exception
      end

      it "creates tags for the pull request" do
        send_pull_request_payload(action: "opened", body: "A request #code #rails")
        expect(Tag.pluck(:name).sort).to eq(["code", "rails"])
      end

      it "uses existing tags if they exist" do
        tag = Tag.create!(name: "rails")
        send_pull_request_payload(action: "opened", body: "A request #rails")
        expect(Tag.pluck(:id)).to eq ([tag.id])
      end

      it "defaults to tagging with #code" do
        send_pull_request_payload(action: "opened", body: "A request with no tags")
        expect(last_pull_request.tags.map(&:name)).to eq(["code"])
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

      it "does not throw an exception when there is no matching pr" do
        expect {
          send_pull_request_review_payload(github_issue_id: 1234)
        }.not_to raise_exception
      end

      context "when the comment includes 'NRR'" do
        it "updates the PullRequest's status to 'needs review'" do
          pr = create(:pull_request, :in_progress)
          send_pull_request_review_payload(
            github_issue_id: pr.github_issue_id,
            comment: "YO this PR NRR"
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

  def send_pull_request_payload(**key_word_args)
    post :create, github_payload: JSON.parse(pull_request_payload(**key_word_args))
  end

  def send_pull_request_review_payload(github_issue_id:, comment: "do you even lift bro?")
    request.headers["X-Github-Event"] = "pull_request_review_comment"
    post :create, github_payload: JSON.parse(
      pull_request_review_comment_payload(
        github_issue_id: github_issue_id,
        comment: comment,
      )
    )
  end

  def send_issue_comment(body:, github_issue_id:)
    request.headers["X-Github-Event"] = "issue_comment"
    post :create, github_payload: JSON.parse(
      issue_comment_payload(body: body, github_issue_id: github_issue_id)
    )
  end

  def last_pull_request
    PullRequest.last
  end
end
