class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_user

  private

  def set_current_user
    @current_user = User.where(id: session[:user_id]).first
  end

  def check_authentication
    unless @current_user
      render_error "Доступ без авторизации запрещен", url: login_path
    end
  end

  def render_error(message = 'Доступ запрещен', options = {})
    flash[:danger] = message
    url = options[:url] || root_path
    redirect_to url
  end

  def authenticate_user(user)
    session[:user_id] = user.id
  end

end
