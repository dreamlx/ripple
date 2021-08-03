class Api::BaseController < ApplicationController
  # disable the CSRF token
  protect_from_forgery with: :null_session

  # disable cookies (no set-cookies header in response)
  before_action :destroy_session
  before_action :authenticate_user!
  attr_accessor :current_user
  
  def api_error(opts = {})
    render body: nil, status: opts[:status]
  end

  def destroy_session
    request.session_options[:skip] = true
  end

  private
    def authenticate_user!
      token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
      
      nickname = options.blank? ? nil : (options["nickname"] || options[:nickname])
      return unauthenticated! if nickname.blank?
      user = User.find_by(nickname: nickname)
      if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
        self.current_user = user
      else
        return unauthenticated!
      end
    end
    
    def unauthenticated!
      api_error(status: 401)
    end
end