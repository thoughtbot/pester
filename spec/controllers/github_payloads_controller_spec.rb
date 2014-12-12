require "rails_helper"

describe GithubPayloadsController do
  context "POST#create" do
    describe "for issue comments" do
      describe "when the comment has 'LGTM'" do
        it "completes the pull request" do
          pr_url = "https://github.com/org/repo/pulls/123"
          issue_url = pr_url.gsub("pulls", "issues")
          create(:pull_request, github_url: pr_url, status: "in progress")

          send_issue_comment(body: "This LGTM :poop:", github_url: issue_url)

          expect(last_pull_request.status).to eq("completed")
        end
      end

      describe "when the comment does not contain 'LGTM'" do
        it "does not modify the pull request" do
          pr_url = "https://github.com/org/repo/pulls/123"
          issue_url = pr_url.gsub("pulls", "issues")
          create(:pull_request, github_url: pr_url, status: "in progress")

          send_issue_comment(body: "This is :poop:", github_url: issue_url)

          expect(last_pull_request.status).to eq("in progress")
        end
      end
    end

    describe "when the action is 'closed'" do
      it "moves the pull request to 'completed'" do
        pr_url = "https://github.com/org/repo/pulls/123"
        create(:pull_request, github_url: pr_url, status: "needs review")

        send_pull_request_payload(action: "closed", github_url: pr_url)

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

      it "posts to slack" do
        create(:tag, name: "rails", webhook_url: "https://google.com/")
        request_stub = stub_request(:post, "https://google.com/").with(body: /.*/)

        send_pull_request_payload(action: "opened", body: "A request #rails")

        expect(request_stub).to have_been_requested
      end
    end

    describe "when the action is 'created'" do
      it "it updates the PullRequest's status to 'in progress'" do
        pr_url = "https://github.com/org/repo/pulls/123"
        create(:pull_request, github_url: pr_url)

        send_pull_request_review_payload(github_url: pr_url)

        expect(last_pull_request.status).to eq("in progress")
      end

      it "does not throw an exception when there is no matching pr" do
        expect {
          send_pull_request_review_payload(github_url: "http://example.com")
        }.not_to raise_exception
      end

      context "when the comment includes 'NRR'" do
        it "updates the PullRequest's status to 'needs review'" do
          pr_url = "https://github.com/org/repo/pulls/123"
          create(:pull_request, :in_progress, github_url: pr_url)

          send_issue_comment(github_url: pr_url, body: "YO this PR NRR")

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

    describe "signature verification" do
      context 'the GitHub secret matches the project correct' do
        it 'returns a success' do
          send_pull_request_payload(action: "opened")

          expect(response.status).to eq(200)
        end
      end

      context 'the GitHub secret does not match the project' do
        it 'returns a 401' do
          post :create, github_payload: JSON.parse(pull_request_payload(action: "opened"))

          expect(response.status).to eq(401)
        end
      end
    end
  end

  def send_pull_request_payload(**key_word_args)
    send_github_request(pull_request_payload(**key_word_args))
  end

  def send_pull_request_review_payload(github_url:)
    request.headers["X-Github-Event"] = "pull_request_review_comment"
    send_github_request(
      pull_request_review_comment_payload(github_url: github_url)
    )
  end

  def send_issue_comment(body:, github_url:)
    request.headers["X-Github-Event"] = "issue_comment"
    send_github_request(
      issue_comment_payload(body: body, github_url: github_url)
    )
  end

  def last_pull_request
    PullRequest.last
  end

  def send_github_request(body)
    request.env["RAW_POST_DATA"] = body
    request.env["HTTP_X_HUB_SIGNATURE"] = create_signature(
      ENV["GITHUB_SECRET_KEY"],
      body,
    )
    post :create, github_payload: JSON.parse(body)
  end

  def create_signature(secret, body)
    "sha1=" + OpenSSL::HMAC.hexdigest(hmac_digest, secret, body)
  end

  def hmac_digest
    OpenSSL::Digest.new("sha1")
  end
end
