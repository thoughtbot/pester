class PayloadParser
  def initialize(payload, headers)
    Rails.logger.ap(payload, :info)
    @payload = payload
    @headers = headers
  end

  def action
    payload["action"]
  end

  def event_type
    headers["HTTP_X_GITHUB_EVENT"]
  end

  def body
    pull_request_or_issue_params["body"] || ""
  end

  def comment
    payload["comment"] || {}
  end

  def github_url
    html_url.gsub("issues", "pulls")
  end

  def comment_user_login
    comment["user"]["login"]
  end

  def params
    {
      github_url: github_url,
      repo_name: repo_name,
      repo_github_url: repo_github_url,
      title: title,
      user_name: user_name,
      user_github_url: user_github_url,
      avatar_url: avatar_url,
    }
  end

  protected

  attr_reader :headers, :payload

  private

  def html_url
    pull_request_or_issue_params["html_url"] || ""
  end

  def pull_request_or_issue_params
    payload["pull_request"] || payload["issue"] || {}
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
    pull_request_user["login"]
  end

  def user_github_url
    payload["pull_request"]["head"]["user"]["html_url"]
  end

  def avatar_url
    pull_request_user["avatar_url"]
  end

  def pull_request_user
    payload["pull_request"]["user"]
  end
end
