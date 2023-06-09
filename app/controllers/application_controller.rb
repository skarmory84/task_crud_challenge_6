class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::MimeResponds

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json {
        render json: { error: 404, message: 'You are not authorized' }, status: :forbidden 
      }
    end
  end
end
