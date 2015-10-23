require "rails_helper"

describe Tag do
  it { should validate_presence_of(:channel) }
  it { should validate_presence_of(:channel_id) }
  it { should validate_presence_of(:name) }
  it { should belong_to(:channel) }
  it { should have_and_belong_to_many(:pull_requests) }

  it "validates the uniqueness of name" do
    _existing_tag = create(:tag, name: "Ember")
    new_tag = build(:tag, name: "Ember")

    expect(new_tag).not_to be_valid
    validation_errors = new_tag.errors.full_messages
    expect(validation_errors).to include("Name has already been taken")
  end

  it "downcases the tag name before saving" do
    tag = create(:tag, name: "UPCASE")
    expect(tag.reload.name).to eq("upcase")
  end

  describe ".with_active_pull_requests" do
    it "returns a unique list of active pull requests" do
      rails_tag = create(:tag, name: "rails")
      ember_tag = create(:tag, name: "ember")
      create(:pull_request, status: "in progress", tags: [ember_tag])
      create(:pull_request, status: "completed", tags: [rails_tag])

      expect(Tag.with_active_pull_requests).to eq([ember_tag])
    end
  end
end
