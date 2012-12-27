class ProjectsController < ApplicationController

  def index
    respond_to do |format|

      format.html do
        page_n = params[:page]

        @projects = Project.listing
            .page(page_n).per(Settings.projects.listing.pages)

        if request.xhr? == 0 # request is ajax
          case params[:selector].to_sym
          when :listing
            logger.info "ID: #{@projects.collect(&:id)}"
            logger.info "PAGE: #{params[:page]}"
            render partial: 'projects/listing', locals: {prjs: @projects}
          end
        end

      end

    end
  end

  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      page_n = params[:page]

      format.html do
        # ==> FETCH THE INFORMATIONS TO RENDER THE VIEW
        # Yin-Yang
        @yinyang = Project.builds_yinyang(@project.id)
        gon.yinyang = @yinyang
        # Dependencies
        @dependencies = Dependency.listing(@project.id)
            .page(page_n).per(Settings.dependencies.listing.pages)
        # Branches
        @branches = Branch.listing(@project.id)
            .page(page_n).per(Settings.branches.listing.pages)

        if request.xhr? != 0 # request isn't ajax
          # ==> RESOURCES SELECTORS SETUP
          @resources_avail = :branches, :builds, :steps, :actions
          gon.current_resource = {
            id: @project.id,
            type: :projects
          }
        end

        render layout: (request.xhr? != 0)
      end

      format.json do
        case params[:selector].to_sym
        when :builds_history
          @builds_history = Project.builds_history_by_date(@project.id)
          render(json: @builds_history)
        end
      end

    end
  end
end
