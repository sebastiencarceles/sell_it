class V1::UsersController < V1::ApplicationController
  before_action :authenticate_user

  def show
    render json: current_user
  end
end
