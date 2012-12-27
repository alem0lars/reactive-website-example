class BuildsController < ApplicationController

  def index
    respond_to do |format|

      format.html do
        page_n = params[:page]

        @builds = if params[:id].nil?
          Build.listing().page(page_n).per(Settings.builds.listing.pages)
        else
          Build.listing(params[:id])
              .page(page_n).per(Settings.branches.builds.listing.pages)
        end

        if request.xhr? == 0 # request is ajax
          case params[:selector].to_sym
          when :listing
            locals = {builds: @builds}
            if params[:id]
              locals[:id] = params[:id]
            end
            render partial: 'builds/listing', locals: locals
          end
        end

      end

      format.json do
        case params[:selector].to_sym
        when :summary
          render(json: Build.summary(params[:id]))
        end
      end

    end
  end

  def show
    @build = Build.joins(:commit)
        .select('builds.*, commits.digest as commit_digest, '\
                'commits.url as commit_url, '\
                'commits.timestamp as commit_timestamp')
        .find(params[:id])

    respond_to do |format|
      format.html do
        if request.xhr? != 0 # request isn't ajax
          # ==> RESOURCES SELECTORS SETUP
          @resources_avail = :steps, :actions
          gon.current_resource = {
            id: @build.id,
            type: :builds
          }
        end

        render layout: (request.xhr? != 0)
      end
    end
  end
end
