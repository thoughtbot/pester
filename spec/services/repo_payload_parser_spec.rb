require 'spec_helper'
require 'services/repo_payload_parser'

describe RepoPayloadParser do
  it("extracts the full name and github url") do
    payload = {
      "other_stuff" => "should not be present",
      "full_name" => "thoughtbot/pr-tool",
      "html_url" => "https://github.com/thoughtbot/pr-tool",
    }
    parser = RepoPayloadParser.new

    expect(parser.parse(payload)).to eq({
      full_name: "thoughtbot/pr-tool",
      github_url: "https://github.com/thoughtbot/pr-tool",
    })
  end
end
