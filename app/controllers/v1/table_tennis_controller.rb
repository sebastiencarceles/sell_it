class V1::TableTennisController < V1::ApplicationController
  def ping
    if current_user
      render json: { response: 'authenticated pong' }
    else
      render json: { response: 'unauthenticated pong'}
    end
  end
end
