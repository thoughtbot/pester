require "rails_helper"

describe PullRequest do
  it { should validate_presence_of(:github_issue_id) }
  it { should validate_presence_of(:github_url) }
  it { should validate_presence_of(:status) }
end
