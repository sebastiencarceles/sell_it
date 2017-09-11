class ApplicationController < ActionController::API
  include Knock::Authenticable

  def ping
    if current_user
      render json: { response: 'authenticated pong' }
    else
      render json: { response: 'unauthenticated ping'}
    end
  end
end
