require "json"
require "httparty"

class GithubApi
  def self.pull_request_status(url)
    response = HTTParty.get(url)
    JSON.parse(response)["state"].to_sym
  end
end
