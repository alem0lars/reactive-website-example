class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :about]

  def home
  end

  def about
  end

  def management
    unless current_user.role == 'manager'
      redirect_to '/home'
    end
  end

end
