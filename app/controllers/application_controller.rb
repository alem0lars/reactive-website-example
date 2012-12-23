class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :fetch_menu, :fetch_sidebar

  def sidebar_tiles
    respond_to do |format|
      format.html do
        search_query = params[:query]
        if search_query && !search_query.empty?
          @prjs_for_sidebar = @prjs_for_sidebar.full_search(search_query)
        end
        render partial: 'sidebar_tiles'
      end
    end
  end

  protected

  def fetch_menu
    default_fetcher('left_menu', :prod_exp_time => 6.days) do
      left_menu = [
        OpenStruct.new(body: 'Home',      url: home_path),
        OpenStruct.new(body: 'About',     url: about_path)
      ]
      if user_signed_in? && current_user.role == 'manager'
        left_menu << OpenStruct.new(body: 'Management', url: management_path)
      end
      left_menu # return
    end
    default_fetcher('right_menu', :prod_exp_time => 6.days) do
      [ OpenStruct.new(body: 'Projects',  url: projects_path),
        OpenStruct.new(body: 'Branches',  url: branches_path),
        OpenStruct.new(body: 'Builds',    url: builds_path),
        OpenStruct.new(body: 'Actions',   url: actions_path)
      ]
    end
  end

  def fetch_sidebar
    page_n = params[:page]
    @prjs_for_sidebar = Project.with_totals.order('projects.id')
        .page(page_n).per(Settings.sidebar.tiles.listing.pages)
  end

  private

  def default_fetcher(name, opts = {}, &block)
    opts = {}.merge({
      prod_exp_time: 10.minutes,
      dev_exp_time: 6.seconds
    })
    exp_time = Rails.env.production? ? opts[:prod_exp_time] : opts[:dev_exp_time]
    instance_variable_set(
      :"@#{name}",
      Rails.cache.fetch(name, :expires_in => exp_time, &block)
    )
  end

end
