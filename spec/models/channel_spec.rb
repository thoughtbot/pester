require "rails_helper"

describe Channel do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:webhook_url) }

  it { should have_many(:projects).dependent(:destroy) }
  it { should have_many(:tags).dependent(:destroy) }
  it { should have_and_belong_to_many(:active_pull_requests) }

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
