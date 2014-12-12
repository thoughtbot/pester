class PayloadParser
  def initialize(payload, headers)
    Rails.logger.ap(payload, :info)
    Rails.logger.ap(headers, :info)
    @payload = payload
    @headers = headers
  end

  def action
    payload["action"]
  end

  def event_type
    headers["X-Github-Event"]
  end

  def body
    pull_request_or_issue_params["body"] || ""
  end

  def comment
    payload["comment"] || {}
  end

  def github_issue_id
    pull_request_or_issue_params["id"]
  end

  def params
    {
      github_issue_id: github_issue_id,
      github_url: github_url,
      repo_name: repo_name,
      repo_github_url: repo_github_url,
      title: title,
      user_name: user_name,
      user_github_url: user_github_url,
    }
  end

  protected

  attr_reader :headers, :payload

  private

  def pull_request_or_issue_params
    payload["pull_request"] || payload["issue"] || {}
  end

  def github_url
    payload["pull_request"]["html_url"]
  end

  def repo_name
    payload["pull_request"]["head"]["repo"]["full_name"]
  end

  def repo_github_url
    payload["pull_request"]["head"]["repo"]["html_url"]
  end

  def title
    payload["pull_request"]["title"]
  end

  def user_name
    payload["pull_request"]["head"]["user"]["login"]
  end

  def user_github_url
    payload["pull_request"]["head"]["user"]["html_url"]
  end
end
