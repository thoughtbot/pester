require "rails_helper"

describe Triggers::SlackController do
  describe "POST#create" do
    it "verifies the team domain is thoughtbot"
    it "verifies the team id is thoughtbot's"
    it "verifies the correct webhook token"

    context "when the channel exists" do
      it "uses the existing channel to beg on"
    end

    context "when the channel does not exist" do
      it "creates a new record to match the channel name from the request"
    end

    context "without a valid github PR link" do
      it "returns an error message"
    end

    context "with a valid github PR link" do
      it "fetches the status of the PR"
      it "starts begging for the PR"
    end
  end

  def slash_command_payload
    {
      "token"=>"JrYJkSSvJB68Wmh4KDSBnEL4",
      "team_id"=>"T024HFHU3",
      "team_domain"=>"thoughtbot",
      "channel_id"=>"C0415Q26Q",
      "channel_name"=>"beggar-test",
      "user_id"=>"U02UQMU1P",
      "user_name"=>"grayson",
      "command"=>"/beg",
      "text"=>"https://github.com/thoughtbot/beggar/82",
    }
  end
end
