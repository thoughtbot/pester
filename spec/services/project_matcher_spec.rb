require "spec_helper"
require "services/project_matcher"

describe ProjectMatcher do
  it "matches when a project has the same github repo name as provided text" do
    url = "http://example.com/thoughtbot/beggar"
    create(:project, github_url: url)

    result = ProjectMatcher.match(url)

    expect(result.first.github_url).to eq(url)
  end
end
