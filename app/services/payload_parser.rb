class PayloadParser
  def initialize(payload, repo_payload_parser)
    @payload = payload
    @repo_payload_parser = repo_payload_parser
  end

  def action
    payload["action"]
  end

  def params
    {
      github_issue_id: github_issue_id,
      github_url: github_url,
      repo_params: repo_params,
    }
  end

  protected

  attr_reader :repo_payload_parser

  private

  def github_issue_id
    payload["pull_request"]["id"]
  end

  def github_url
    payload["pull_request"]["html_url"]
  end

  def repo_params
    repo_payload_parser.parse(payload["pull_request"]["head"]["repo"])
  end

  def payload
    @_payload ||= JSON.parse(@payload)
  end
end
