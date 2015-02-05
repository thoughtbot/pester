require "rails_helper"

describe CreateNewPr do
  describe ".matches" do
    context "when there are no tags" do
      it "is false" do
        parser = double(
          :parser,
          action: "opened",
          body: "There are no tags here",
        )

        expect(CreateNewPr.matches(parser, nil)).to be false
      end
    end
  end
end
