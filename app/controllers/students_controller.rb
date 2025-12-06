class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :update, :destroy]
  before_action :authorize_teacher_or_admin!
  before_action :check_delete_permission, only: [:destroy]

  def index
    students = current_school.students
    render json: students, status: :ok
  end

  def show
    render json: @student, status: :ok
  end

  def create
    student = current_school.students.build(student_params)
    
    if student.save
      render json: student, status: :created
    else
      render json: { errors: student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @student.update(student_params)
      render json: @student, status: :ok
    else
      render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    head :no_content
  end

  private

  def set_student
    @student = current_school.students.find(params[:id])
  end

  def check_delete_permission
    unless current_user.admin?
      render json: { error: 'Apenas administradores podem excluir alunos' }, status: :forbidden
    end
  end

  def student_params
    params.require(:student).permit(:name, :email, :registration_number, :phone)
  end
end
