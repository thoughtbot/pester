require "rails_helper"

describe MarkPrInProgress do
  describe ".matches" do
    context "when the user is houndci" do
      it "is false" do
        parser = double(
          :parser,
          comment_user_login: "houndci",
          event_type: "pull_request_review_comment",
        )

        expect(MarkPrInProgress.matches(parser, nil)).to be false
      end
    end
  end
end
