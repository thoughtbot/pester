require "rails_helper"

describe PullRequest do
  it { should validate_presence_of(:github_url) }
  it { should validate_presence_of(:repo_name) }
  it { should validate_presence_of(:status) }

  describe ".needs_reposting" do
    it "returns PRs that haven't been reviewed in over 30 minutes nor reposted" do
      pr_to_report = create(:pull_request, :needs_review, reposted: false)
      _reposted_pr = create(:pull_request, :needs_review, reposted: true)
      _pr_in_progress = create(:pull_request, :in_progress)

      travel(31.minutes) do
        expect(PullRequest.needs_reposting).to eq [pr_to_report]
      end
    end
  end

  describe ".updated_before" do
    it "returns pull requests that have not been updated since a given time" do
      older_pr = create(:pull_request)

      travel(31.minutes) do
        _recently_updated_pr = create(:pull_request)
        expect(PullRequest.updated_before(30.minutes.ago)).to eq [older_pr]
      end
    end
  end
end
