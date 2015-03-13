class ProjectMatcher
  def self.match(github_url)
    Project.where(github_url: github_url)
  end
end
