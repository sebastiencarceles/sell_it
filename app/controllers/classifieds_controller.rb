
class ClassifiedsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update]

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

  def update
    classified = Classified.find_by(id: params[:id])
    render json: {}, status: :not_found and return unless classified
    render json: {}, status: :forbidden and return unless current_user.id == classified.user_id
    # Another way: use current_user.classifieds.find_by and let the server return a 404
    if classified.update(classified_params)
      render json: classified
    else
      render json: classified.errors.details, status: :bad_request
    end
  end

  private

  def classified_params
    params.require(:classified).permit(:title, :price, :description)
  end
end
