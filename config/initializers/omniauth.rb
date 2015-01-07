Rails.application.config.middleware.use OmniAuth::Builder do
  THOUGHTBOT_TEAM_ID = 3675
  provider :githubteammember,
    ENV["GITHUB_CLIENT_ID"],
    ENV["GITHUB_CLIENT_SECRET"],
    scope: "read:org",
    teams: {
      "thoughtbot_team_member?" => THOUGHTBOT_TEAM_ID
    }
end
