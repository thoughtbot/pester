FactoryGirl.define do
  factory :pull_request do
    sequence(:github_issue_id)
    github_url "https://github.com/thoughtbot/stuff/pulls/1"
    repo_github_url "https://github.com/thoughtbot/stuff"
    sequence(:repo_name) { |n| "repo-#{n}" }
    status "needs review"
    title "Doing Stuff"
    user_name "sgrif"
    user_github_url "https://github.com/thoughtbot/sgrif"
  end

  factory :tag do
    name "code"
  end
end
