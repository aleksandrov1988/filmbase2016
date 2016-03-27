class GenresController < ApplicationController
  before_action :check_authentication, except: :index
  before_action :set_genre, only: [:show, :edit, :update, :destroy]
  before_action :check_edit, except: [:index, :show]

  def index
    @genres = Genre.ordering.page(params[:page])
  end

  def show
    @films = @genre.films.page(params[:page])
  end

  def new
    @genre = Genre.new
  end

  def edit
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to @genre, notice: 'Жанр создан.'
    else
      render :new
    end
  end

  def update
    if @genre.update(genre_params)
      redirect_to @genre, notice: 'Жанр изменен.'
    else
      render :edit
    end
  end

  def destroy
    if @genre.destroy
      redirect_to genres_url, notice: 'Жанр удален.'
    else
      render_error('Удаление жанра невозможно', url: @genre)
    end
  end

  private
  def set_genre
    @genre = Genre.find(params[:id])
  end

  def genre_params
    params.require(:genre).permit(:name)
  end

  def check_edit
    render_error unless Genre.edit_by?(@current_user)
  end
end
