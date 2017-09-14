class V2::ClassifiedsController < V1::ClassifiedsController
  def index
    [:page, :per_page, :order].each do |param_sym|
      render json: { error: "missing parameter #{param_sym.to_s}" }, status: :bad_request and return unless params[param_sym]
    end
    render json: { error: 'order parameter must be asc or desc' }, status: :bad_request and return unless params[:order] == 'asc' || params[:order] == 'desc'
    scope = Classified.where(category: params[:category]) if params[:category]
    scope ||= Classified.all
    paginate json: scope.order(created_at: params[:order]), status: :partial_content
  end

  def update
    render json: {}, status: :forbidden
  end
end
