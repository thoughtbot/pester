require "github_api"

describe GithubApi do
  describe ".pull_request_status" do
    it "returns :open for open pull requests"
    it "returns :closed for closed pull requests"
  end
end
