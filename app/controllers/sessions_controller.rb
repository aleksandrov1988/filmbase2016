class SessionsController < ApplicationController
  def new
  end

  def create
    @email = params[:email]
    user = User.where(email: @email).first
    if user && user.authenticate(params[:password])
      authenticate_user(user)
      redirect_to root_path, notice: 'Авторизация выполнена'
    else
      flash[:danger] = "Неверный адрес электронной почты или пароль"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'Сеанс работы в системе завершен'
  end
end
