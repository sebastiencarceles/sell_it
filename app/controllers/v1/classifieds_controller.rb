
class V1::ClassifiedsController < ApplicationController

  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :find_classified, only: [:show, :update, :destroy]
  before_action :check_authorization, only: [:update, :destroy]

  def index
    render json: { error: 'missing parameters' }, status: :bad_request and return unless params[:page] && params[:per_page]
    paginate json: Classified.all, status: :partial_content
  end

  def show
    render json: @classified
  end

  def create
    classified = current_user.classifieds.create(classified_params)
    render json: classified, status: :created and return if classified.save
    render json: classified.errors.details, status: :bad_request
  end

  def update
    render json: @classified and return if @classified.update(classified_params)
    render json: @classified.errors.details, status: :bad_request
  end

  def destroy
    render json: {}, status: :no_content and return if @classified.destroy
    render json: @classified.errors.details, status: :bad_request
  end

  def publish
    # Really publish the classified here
    render json: { status: 'published' }, status: :created
  end

  private

  def find_classified
    @classified = Classified.find_by(id: params[:id])
    render json: {}, status: :not_found and return unless @classified
  end

  def check_authorization
    render json: {}, status: :forbidden and return unless current_user.id == @classified.user_id
  end

  def classified_params
    params.require(:classified).permit(:title, :price, :description)
  end
end
