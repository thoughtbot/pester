Rails.application.config.middleware.use OmniAuth::Builder do
  provider :githubteammember,
    ENV.fetch("GITHUB_CLIENT_ID"),
    ENV.fetch("GITHUB_CLIENT_SECRET"),
    scope: "read:org",
    teams: { "team_member?" => ENV.fetch("GITHUB_TEAM_ID") }
end
