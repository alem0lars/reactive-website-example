class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:username], params[:password], params[:remember_me])
    if user
      flash[:success] = 'Logged in.'
    else
      flash[:error] = 'Incorrect username or password.'
    end
    redirect_back_or_to root_url
  end

  def destroy
    logout
    flash[:info] = 'Logged out.'
    redirect_to root_url
  end
end
