class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :update, :destroy]
  before_action :authorize_teacher_or_admin!
  before_action :check_subject_permission, only: [:update, :destroy]

  def index
    subjects = if current_user.admin?
      current_school.subjects
    else
      current_school.subjects.where(teacher_id: current_user.id)
    end
    
    render json: subjects.map { |s| subject_json(s) }, status: :ok
  end

  def show
    unless current_user.admin? || @subject.teacher_id == current_user.id
      return render json: { error: 'Access denied' }, status: :forbidden
    end

    render json: subject_json(@subject), status: :ok
  end

  def create
    subject = current_school.subjects.build(subject_params)
    
    # If teacher creates, set themselves as teacher
    if current_user.teacher?
      subject.teacher_id = current_user.id
    end
    
    if subject.save
      render json: subject_json(subject), status: :created
    else
      render json: { errors: subject.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @subject.update(subject_update_params)
      render json: subject_json(@subject), status: :ok
    else
      render json: { errors: @subject.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @subject.destroy
    head :no_content
  end

  private

  def set_subject
    @subject = current_school.subjects.find(params[:id])
  end

  def check_subject_permission
    unless current_user.admin? || @subject.teacher_id == current_user.id
      render json: { error: 'You can only manage your own subjects' }, status: :forbidden
    end
  end

  def subject_params
    params.require(:subject).permit(
      :name, :code, :number_of_grades, :passing_average, :recovery_average, :teacher_id
    )
  end

  def subject_update_params
    allowed = [:name, :number_of_grades, :passing_average, :recovery_average]
    # Only admin can change code and teacher
    allowed += [:code, :teacher_id] if current_user.admin?
    
    params.require(:subject).permit(*allowed)
  end

  def subject_json(subject)
    {
      id: subject.id.to_s,
      name: subject.name,
      code: subject.code,
      number_of_grades: subject.number_of_grades,
      passing_average: subject.passing_average,
      recovery_average: subject.recovery_average,
      teacher_id: subject.teacher_id.to_s,
      teacher_name: subject.teacher.name,
      school_id: subject.school_id.to_s,
      created_at: subject.created_at,
      updated_at: subject.updated_at
    }
  end
end
