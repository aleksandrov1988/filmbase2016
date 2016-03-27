class PeopleController < ApplicationController
  before_action :check_authentication, except: :index
  before_action :check_edit, except: [:index, :show]
  before_action :set_person, only: [:show, :edit, :update, :destroy]


  def index
    respond_to do |format|
      format.html{@people = Person.ordering.page(params[:page])}
      format.json{@people = Person.search(params[:q]).all}
    end
  end

  def show
  end


  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person, notice: 'Персона создана.'
    else
      render :new
    end
  end

  def update
    if @person.update(person_params)
      redirect_to @person, notice: 'Персона изменена.'
    else
      render :edit
    end
  end

  def destroy
    if @person.destroy
      redirect_to people_url, notice: 'Персона удалена.'
    else
      render_error('Удаление персоны невозможно', url: @person)
    end
  end

  private
  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :origin_name, :birthday, :avatar)
  end

  def check_edit
    render_error unless Person.edit_by?(@current_user)
  end
end
