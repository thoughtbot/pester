module Triggers
  class SlackController < ApplicationController
    skip_before_filter :ensure_thoughtbot_team

    before_filter :ensure_thoughtbot_team
    before_filter :only_respond_to_beg_command

    def create
      render status: :ok, text: t("trigger.slack.missing_pr_link")
    end

    private

    def ensure_thoughtbot_team
      if params[:team_domain] != ENV.fetch("SLACK_TEAM_DOMAIN") &&
        params[:team_id] != ENV.fetch("SLACK_TEAM_ID")
        forbidden
      end
    end

    def only_respond_to_beg_command
      unless params[:command] == "/beg"
        forbidden
      end
    end

    def forbidden
      render status: :forbidden, text: "Forbidden"
    end
  end
end
