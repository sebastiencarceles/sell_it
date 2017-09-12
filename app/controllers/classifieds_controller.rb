
class ClassifiedsController < ApplicationController
  before_action :authenticate_user, only: :create

  def index
    render json: Classified.all
  end

  def show
    render json: Classified.find(params[:id])
  end

  def create
    classified = current_user.classifieds.create(classified_params)
    if classified.save
      render json: classified, status: :created
    else
      render json: classified.errors.details, status: :bad_request
    end
  end

  private

  def classified_params
    params.permit(:title, :price, :description)
  end
end
