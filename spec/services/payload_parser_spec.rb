require "rails_helper"

describe PayloadParser do
  describe "#comment_user_login" do
    it "is the comment user from the payload" do
      payload = JSON.parse(
        pull_request_review_comment_payload(comment_user: "houndci")
      )

      parser = PayloadParser.new(payload, nil)

      expect(parser.comment_user_login).to eq("houndci")
    end
  end

  describe "#params" do
    it "user_name" do
      payload = JSON.parse(pull_request_payload(user_name: "spiderman"))

      parser = PayloadParser.new(payload, nil)

      expect(parser.params[:user_name]).to eq("spiderman")
    end

    it "avatar_url" do
      payload = JSON.parse(
        pull_request_payload(avatar_url: "http://example.com")
      )

      parser = PayloadParser.new(payload, nil)

      expect(parser.params[:avatar_url]).to eq("http://example.com")
    end

    it "additions and deletions" do
      payload = JSON.parse(
        pull_request_payload(additions: 1, deletions: 20)
      )

      parser = PayloadParser.new(payload, nil)

      expect(parser.params[:additions]).to eq(1)
      expect(parser.params[:deletions]).to eq(20)
    end

    it "calculates the number of comments" do
      payload = JSON.parse(
        pull_request_payload(comments: 2, review_comments: 3)
      )

      parser = PayloadParser.new(payload, nil)

      expect(parser.params[:comment_count]).to eq(5)
    end
  end
end
