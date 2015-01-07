class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_filter :ensure_thoughtbot_team
  force_ssl if: :ssl_configured?


  private

  def ensure_thoughtbot_team
    unless github_username || Rails.env.test?
      redirect_to new_session_path
    end
  end

  def github_username
    session[:github_username]
  end

  def ssl_configured?
    !Rails.env.development? && !Rails.env.test?
  end
end
