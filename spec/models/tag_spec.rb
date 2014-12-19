require "rails_helper"

describe Tag do
  describe ".with_name" do
    it "will only create tags for supported tag names" do
      expect(Tag.with_name("random_name")).to be_nil
    end
  end
end
