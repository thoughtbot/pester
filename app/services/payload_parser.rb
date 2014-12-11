class PayloadParser
  def initialize(payload)
    @payload = payload
  end

  def action
    payload["action"]
  end

  def params
    {
      github_issue_id: github_issue_id,
      github_url: github_url,
      repo_name: repo_name,
    }
  end

  private

  def github_issue_id
    payload["pull_request"]["id"]
  end

  def github_url
    payload["pull_request"]["html_url"]
  end

  def repo_name
    payload["pull_request"]["head"]["repo"]["full_name"]
  end

  def payload
    @_payload ||= JSON.parse(@payload)
  end
end
