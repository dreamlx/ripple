class Admin::SessionsController < Admin::BaseController
  skip_before_action :logged_in
  def new
  end

  def create
    admin = Admin.find_by(name: params[:session][:name]) rescue nil
    if admin && admin.authenticate(params[:session][:password])
      admin_log_in admin
      redirect_to admin_root_url
    else
      flash.now[:danger] = t(:invalid_email_or_password)
      render 'new'
    end
  end

  def destroy
    admin_logout if admin_logged_in?
    redirect_to admin_root_url
  end
end