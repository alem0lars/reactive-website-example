class DependenciesController < ApplicationController

  def index
    respond_to do |format|

      format.html do
        page_n = params[:page]

        @dependencies = Dependency.listing(params[:id] || nil)
            .page(page_n).per(Settings.dependencies.listing.pages)

        if request.xhr? == 0 # request is ajax
          case params[:selector].to_sym
          when :listing
            locals = {deps: @dependencies}
            if params[:id]
              locals[:id] = params[:id]
            end
            render partial: 'dependencies/listing', locals: locals
          end
        end

      end

    end
  end

end
