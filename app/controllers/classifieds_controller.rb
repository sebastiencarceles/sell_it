
class ClassifiedsController < ApplicationController
  def index
    render json: Classified.all
  end

  def show
    render json: Classified.find(params[:id])
  end
end
