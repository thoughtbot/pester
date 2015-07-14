FactoryGirl.define do
  factory :channel do
    sequence(:name) { |n| "channel#{n}" }
    webhook_url "http://example.com/home"

    transient do
      tag_name nil
    end

    after :create do |channel, evaluator|
      if evaluator.tag_name.present?
        create(:tag, name: evaluator.tag_name, channel: channel)
      end
    end
  end

  factory :project do
    sequence(:name) { |n| "project#{n}" }
    sequence(:github_url) { |n| "http://example.com/thoughtbot/project#{n}" }
    association :default_channel, factory: :channel
  end

  factory :pull_request do
    sequence(:github_url) {|n| "https://github.com/thoughtbot/stuff/pulls/#{n}"}
    repo_github_url { "https://github.com/#{repo_name}" }
    sequence(:repo_name) { |n| "thoughtbot/stuff-#{n}" }
    status "needs review"
    title "Doing Stuff"
    user_name "sgrif"
    user_github_url "https://github.com/thoughtbot/sgrif"

    trait :in_progress do
      status "in progress"
    end

    trait :needs_review do
      status "needs review"
    end

    trait :stale do
      updated_at { 31.minutes.ago }
    end
  end

  factory :tag do
    name "code"
    channel
  end
end
