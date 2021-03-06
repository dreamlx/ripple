class Admin::WelcomeController < Admin::BaseController
  skip_before_action :logged_in
  def index
    @home = Home.new
    @day = params[:home] ? Date.parse(params[:home][:date]) : Date.today
  end

  def output
    @day = params[:home] ? Date.parse(params[:home][:date]) : Date.today
    render xlsx: 'welcome/output'
  end
end