class ApplicationController < ActionController::Base
  rescue_from ActionController::BadRequest do |e|
    render json: { message: e.message }, status: 400
  end
end
