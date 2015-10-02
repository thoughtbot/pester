require "rails_helper"

describe Channel do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:webhook_url) }

  it { should have_many(:projects).dependent(:destroy) }
  it { should have_many(:tags).dependent(:destroy) }
  it { should have_many(:active_pull_requests).through(:tags) }

  describe ".with_active_pull_requests" do
    it "returns a unique list of active pull requests" do
      channel = create(:channel, name: "cool_project")
      rails_tag = create(:tag, name: "rails", channel: channel)
      ember_tag = create(:tag, name: "ember", channel: channel)
      create(:pull_request, status: "in progress", tags: [rails_tag, ember_tag])
      create(:pull_request, status: "completed", tags: [rails_tag])

      expect(Channel.with_active_pull_requests).to eq([channel])
    end
  end

  describe ".with_tag_name" do
    it "will return the channel with the given tag name" do
      matching_channel = create(:channel)
      other_channel = create(:channel)
      create(:tag, name: "rails", channel: matching_channel)
      create(:tag, name: "ruby", channel: matching_channel)
      create(:tag, name: "javascript", channel: other_channel)

      found_channel = Channel.with_tag_name("rails")

      expect(found_channel).to eq(matching_channel)
    end
  end
end
