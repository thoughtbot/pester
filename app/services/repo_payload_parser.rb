class RepoPayloadParser
  def parse(payload)
    {
      full_name: payload["full_name"],
      github_url: payload["html_url"],
    }
  end
end
