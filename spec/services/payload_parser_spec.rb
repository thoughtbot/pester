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
    it "extras the proper username from pull request params" do
      payload = JSON.parse(pull_request_payload(user_name: "spiderman"))

      parser = PayloadParser.new(payload, nil)

      expect(parser.params[:user_name]).to eq("spiderman")
    end

    it "extracts the proper avatar_url" do
      payload = JSON.parse(
        pull_request_payload(avatar_url: "http://example.com")
      )

      parser = PayloadParser.new(payload, nil)

      expect(parser.params[:avatar_url]).to eq("http://example.com")
    end
  end
end
