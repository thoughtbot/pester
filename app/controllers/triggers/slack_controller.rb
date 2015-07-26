module Triggers
  class SlackController < ApplicationController
    skip_before_filter :ensure_thoughtbot_team

    before_filter :ensure_expected_parameters

    def create
      render status: :ok, text: t("trigger.slack.missing_pr_link")
    end

    private

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
  end
end
