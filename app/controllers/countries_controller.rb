class CountriesController < ApplicationController
  before_action :check_authentication, except: :index
  before_action :check_edit, except: [:index, :show]
  before_action :set_country, only: [:show, :edit, :update, :destroy]


  def index
    @countries = Country.ordering.page(params[:page])
  end

  def show
    @films = @country.films.page(params[:page])
  end

  def new
    @country = Country.new
  end

  def edit
  end

  def create
    @country = Country.new(country_params)
    if @country.save
      redirect_to @country, notice: 'Страна создана.'
    else
      render :new
    end
  end

  def update
    if @country.update(country_params)
      redirect_to @country, notice: 'Страна изменена.'
    else
      render :edit
    end
  end

  def destroy
    if @country.destroy
      redirect_to countries_url, notice: 'Страна удалена.'
    end
  end

  private
  def set_country
    @country = Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:name)
  end

  def check_edit
    render_error unless Country.edit_by?(@current_user)
  end
end
