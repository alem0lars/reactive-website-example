class UsersController < ApplicationController

  def create
    user = User.new(
      username: params[:username],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    if user.save
      flash[:success] = 'Signed up.'
    else
      flash[:error] = "Unable to sign up:"
      if user.errors.any?
        flash[:error] += '<ul>'
        user.errors.each { |error| flash[:error] += "<li>Invalid: #{error}</li>" }
        flash[:error] += '</ul>'
      end
    end
    redirect_back_or_to root_url
  end
end
