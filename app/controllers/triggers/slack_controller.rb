class Triggers::SlackController < ApplicationController
  skip_before_filter :ensure_thoughtbot_team

  def create
    render text: "This is a dummy command - implementation coming soon!"
  end
end
