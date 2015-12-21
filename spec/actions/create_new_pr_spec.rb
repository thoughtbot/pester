require "rails_helper"

describe CreateNewPr do
  describe ".matches" do
    context "when there are no tags" do
      it "is false" do
        parser = double(
          :parser,
          action: "opened",
          body: "There are no tags here",
          repo_github_url: "http://example.com/"
        )

        expect(CreateNewPr.matches(parser, nil)).to be false
      end
    end

    context "when there is a project" do
      it "is true with tags" do
        project_url = "http://example.com/thoughtbot/pester"
        create(:project, github_url: project_url)
        parser = double(
          :parser,
          action: "opened",
          body: "#rails",
          repo_github_url: project_url
        )

        expect(CreateNewPr.matches(parser, nil)).to be true
      end

      it "is true without tags" do
        project_url = "https://github.com/thoughtbot/pester"
        create(:project, github_url: project_url)
        parser = double(
          :parser,
          action: "opened",
          body: "No tags, no tags",
          repo_github_url: project_url
        )

        expect(CreateNewPr.matches(parser, nil)).to be true
      end
    end
  end

  describe ".tags" do
    it "creates the pull request with the original tags" do
      rails = create(:tag, name: "rails")
      ember = create(:tag, name: "ember")
      parser = double(
        :parser,
        action: "opened",
        body: "#rails #ember",
        params: attributes_for(:pull_request),
        repo_github_url: "_",
      )
      pr_creator = CreateNewPr.new(parser, nil)
      allow(pr_creator).to receive(:post_to_slack)

      pr_creator.call

      pull_request = PullRequest.last
      expect(pull_request.tags).to match_array([rails, ember])
    end
  end
end
