desc "Reposts PRs that have not been reviewed for over 30 min. nor reposted"
task repost_prs: :environment do
  PullRequestReposter.run(PullRequest.needs_reposting)
end
