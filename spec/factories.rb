FactoryGirl.define do
  factory :pull_request do
    github_issue_id 123
    github_url "https://github.com/thoughtbot/stuff/pulls/1"
    repo_github_url "https://github.com/thoughtbot/stuff"
    repo_name "thoughtbot/stuff"
    title "Doing Stuff"
    user_name "sgrif"
    user_github_url "https://github.com/thoughtbot/sgrif"
  end
end
