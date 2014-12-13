require "rails_helper"

describe "#params" do
  it "extras the proper username from pull request params" do
    payload = JSON.parse(pull_request_payload(user_name: "spiderman"))

    parser = PayloadParser.new(payload, nil)

    expect(parser.params[:user_name]).to eq("spiderman")
  end

  it "extracts the proper avatar_url" do
    payload = JSON.parse(pull_request_payload(avatar_url: "http://example.com"))

    parser = PayloadParser.new(payload, nil)

    expect(parser.params[:avatar_url]).to eq("http://example.com")
  end
end
