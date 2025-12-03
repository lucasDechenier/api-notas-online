class SchoolsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :set_school, only: [:show, :update, :destroy]
  before_action :authorize_admin!, except: [:create, :show]

  def index
    if current_user.admin?
      schools = School.all
    else
      schools = School.where(id: current_school.id)
    end
    render json: schools, status: :ok
  end

  def show
    render json: @school, status: :ok
  end

  def create
    school = School.new(school_params)
    
    if school.save
      render json: school, status: :created
    else
      render json: { errors: school.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @school.update(school_params)
      render json: @school, status: :ok
    else
      render json: { errors: @school.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @school.destroy
    head :no_content
  end

  private

  def set_school
    @school = if current_user&.admin?
      School.find(params[:id])
    else
      current_school
    end
  end

  def school_params
    params.require(:school).permit(:name, :address, :phone, :email)
  end
end
