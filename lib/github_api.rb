require "json"
require "httparty"

class GithubApi
  def self.pull_request_status(pr_url)
    new(pr_url).pull_request_status
  end

  def initialize(pr_url)
    @pr_url = pr_url
  end

  def pull_request_status
    p authenticated_api_url
    response = HTTParty.get(authenticated_api_url)
    JSON.parse(response.body)["state"].to_sym
  end

  private

  attr_reader :pr_url

  def authenticated_api_url
    "#{api_url}?client_id=#{client_id}&client_secret=#{client_secret}"
  end

  def api_url
    "https://api.github.com/repos/#{repo_path}/pulls/#{pr_number}"
  end

  def repo_path
    matches[1]
  end

  def pr_number
    matches[2]
  end

  def matches
    pr_url.match(/github.com\/(.+\/.+)\/pull\/(\d+)/)
  end

  def client_id
    ENV.fetch("GITHUB_CLIENT_ID")
  end

  def client_secret
    ENV.fetch("GITHUB_CLIENT_SECRET")
  end
end
