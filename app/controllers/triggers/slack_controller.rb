require "github_api"

module Triggers
  class SlackController < ApplicationController
    skip_before_filter :ensure_thoughtbot_team

    before_filter :ensure_expected_parameters

    def create
      if params[:text].match(/github.com/).nil?
        respond_with_message t("trigger.slack.missing_pr_link")
      elsif !Project.exists?(github_url: repo_url)
        respond_with_message t("trigger.slack.webhook_not_configured")
      elsif pull_request_closed?
        respond_with_message t("trigger.slack.pull_request_closed")
      else
        channels = Channel.where(name: params[:channel_name])
        if channels.none?
          channel = Channel.create!(
            name: params[:channel_name],
            webhook_url: "https://hooks.slack.com/services/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",
          )
          channels = [channel]
        end
        PullRequest.create!(
          github_url: pull_request_url,
          repo_name: "Foobar",
          repo_github_url: "Foobar",
          title: "Foobar",
          user_name: "Foobar",
          user_github_url: "Foobar",
          channels: channels,
        )
        respond_with_message t("trigger.slack.success")
      end
    end

    private

    def pull_request_closed?
      GithubApi.pull_request_status(pull_request_url) == :closed
    end

    def pull_request_url
      params[:text]
    end

    def repo_url
      pull_request_url.split("/pull/").first
    end

    def ensure_expected_parameters
      unless all_expected_parameters_correct?
        forbidden
      end
    end

    def all_expected_parameters_correct?
      expected_parameters.all? do |param, expected_value|
        params[param] == expected_value
      end
    end

    def expected_parameters
      {
        command: "/beg",
        team_domain: ENV.fetch("SLACK_TEAM_DOMAIN"),
        team_id: ENV.fetch("SLACK_TEAM_ID"),
      }
    end

    def forbidden
      render status: :forbidden, text: "Forbidden"
    end

    def respond_with_message(message)
      render status: :ok, text: message
    end
  end
end
