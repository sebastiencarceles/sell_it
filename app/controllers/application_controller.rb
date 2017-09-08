class ApplicationController < ActionController::API
  def ping
    render json: { response: 'pong' }
  end
end
