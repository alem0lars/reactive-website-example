class ActionsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json do
        case params[:selector].to_sym
        when :summary
          render(json: Action.summary(params[:id]))
        end
      end
    end
  end

  def show
    @action = Action.find(params[:id])

    respond_to do |format|
      format.html do
        render layout: (request.xhr? != 0)
      end
    end
  end

end
