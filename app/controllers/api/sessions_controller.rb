class Api::SessionsController < Api::BaseController
  skip_before_action :authenticate_user!
  def create
    user = User.find_by(nickname: params[:nickname])

    if user && user.authenticate(params[:password])
      self.current_user = @user
      return render json: {token: user.authentication_token, nickname: user.nickname, name: user.name}
    else
      return api_error(status: 401)
    end
  end
end