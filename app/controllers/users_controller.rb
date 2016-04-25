class UsersController < ApplicationController
  before_action :check_edit, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def index
    @users = User.ordering.page(params[:page])
  end

  def show
  end


  def new
    @user = User.new
  end


  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if @current_user
        redirect_to @user, notice: 'Пользователь создан'
      else
        authenticate_user(@user)
        redirect_to root_path, notice: 'Регистрация завершена'
      end
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Пользователь изменен.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'Пользователь удален'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    attrs = [:name, :email, :password, :password_confirmation]
    attrs << :role if @current_user.try(:admin?)
    params.require(:user).permit(attrs)
  end

  def check_edit
    render_error unless User.edit_by?(@current_user)
  end
end
