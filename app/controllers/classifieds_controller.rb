class ClassifiedsController < ApplicationController
  def show
    render json: Classified.find(params[:id])
  end
end
