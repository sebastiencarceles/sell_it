class V2::ClassifiedsController < V1::ClassifiedsController
  def update
    render json: {}, status: :forbidden
  end
end
