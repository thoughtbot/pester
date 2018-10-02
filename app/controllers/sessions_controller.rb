class SessionsController < ApplicationController
  skip_before_action :ensure_team_member

  def new

  end

  def create
    if auth_hash.credentials.team_member?
      session[:github_username] = github_username
      redirect_to root_path
    else
      flash[:error] = "You cannot access this site" \
                      "unless you are a member of the team"
      redirect_to root_path
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env["omniauth.auth"]
  end

  def github_username
    auth_hash["info"]["nickname"]
  end
end
