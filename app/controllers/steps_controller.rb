class StepsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json do
        case params[:selector].to_sym
        when :summary
          render(json: Step.summary(params[:id]))
        end
      end
    end
  end

  def show
    @step = Step.find(params[:id])

    respond_to do |format|
      format.html do
        if request.xhr? != 0 # request isn't ajax
          # ==> RESOURCES SELECTORS SETUP
          @resources_avail = [:actions]
          gon.current_resource = {
            id: @step.id,
            type: :steps
          }
        end

        render layout: (request.xhr? != 0)
      end
    end

  end
end
