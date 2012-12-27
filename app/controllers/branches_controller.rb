class BranchesController < ApplicationController

  def index
    respond_to do |format|

      format.html do
        page_n = params[:page]

        @branches = Branch.listing(params[:id] || nil)
            .page(page_n).per(Settings.branches.listing.pages)

        if request.xhr? == 0 # request is ajax
          case params[:selector].to_sym
          when :listing
            locals = {branches: @branches}
            if params[:id]
              locals[:id] = params[:id]
            end
            render partial: 'branches/listing', locals: locals
          end
        end

      end

      format.json do
        case params[:selector].to_sym
        when :summary
          render(json: Branch.summary(params[:id]))
        end
      end

    end
  end

  def show
    @branch = Branch.find(params[:id])

    respond_to do |format|
      page_n = params[:page]

      format.html do
        # ==> FETCH THE INFORMATIONS TO RENDER THE VIEW
        # Yin-Yang
        @yinyang = Branch.builds_yinyang(@branch.id)
        gon.yinyang = @yinyang
        # Builds
        @builds = Build.listing(@branch.id)
            .page(page_n).per(Settings.builds.listing.pages)

        if request.xhr? != 0 # request isn't ajax
          # ==> RESOURCES SELECTORS SETUP
          @resources_avail = :builds, :steps, :actions
          gon.current_resource = {
            id: @branch.id,
            type: :branches
          }
        end

        render layout: (request.xhr? != 0)
      end

    end
  end
end
