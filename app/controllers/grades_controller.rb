class GradesController < ApplicationController
  before_action :set_grade, only: [:show, :update, :destroy]
  before_action :authorize_teacher_or_admin!
  before_action :check_grade_permission, only: [:update, :destroy]

  def index
    grades = if current_user.admin?
      current_school.grades
    else
      # Teachers only see grades from their subjects
      subject_ids = current_user.subjects.pluck(:id)
      current_school.grades.in(subject_id: subject_ids)
    end
    
    # Filter by student or subject if provided
    grades = grades.where(student_id: params[:student_id]) if params[:student_id]
    grades = grades.where(subject_id: params[:subject_id]) if params[:subject_id]
    
    render json: grades.map { |g| grade_json(g) }, status: :ok
  end

  def show
    render json: grade_json(@grade), status: :ok
  end

  def create
    # Validate student exists and belongs to current school
    student = current_school.students.find_by(id: grade_create_params[:student_id])
    unless student
      return render json: { error: 'Aluno não encontrado ou não pertence à sua escola' }, status: :not_found
    end

    # Validate subject exists and belongs to current school
    subject = current_school.subjects.find_by(id: grade_create_params[:subject_id])
    unless subject
      return render json: { error: 'Disciplina não encontrada ou não pertence à sua escola' }, status: :not_found
    end

    # Validate that subject belongs to current user if teacher
    if current_user.teacher? && subject.teacher_id != current_user.id
      return render json: { error: 'Você só pode criar notas para suas disciplinas' }, status: :forbidden
    end

    # Build grade with validated relationships
    grade = current_school.grades.build(grade_create_params)

    if grade.save
      render json: grade_json(grade), status: :created
    else
      render json: { errors: grade.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # Handle adding or updating scores
    if params[:grade][:add_score]
      score = params[:grade][:add_score].to_f
      if @grade.add_score(score, Time.current)
        @grade.save
        render json: grade_json(@grade), status: :ok
      else
        render json: { errors: @grade.errors.full_messages }, status: :unprocessable_entity
      end
    elsif params[:grade][:update_score]
      index = params[:grade][:score_index].to_i
      score = params[:grade][:update_score].to_f
      if @grade.update_score(index, score, Time.current)
        @grade.save
        render json: grade_json(@grade), status: :ok
      else
        render json: { errors: @grade.errors.full_messages }, status: :unprocessable_entity
      end
    elsif params[:grade][:scores]
      # Direct score update
      if @grade.update(scores: params[:grade][:scores], score_dates: Array.new(params[:grade][:scores].length, Time.current))
        render json: grade_json(@grade), status: :ok
      else
        render json: { errors: @grade.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Nenhum parâmetro de atualização válido fornecido' }, status: :unprocessable_entity
    end
  end

  def destroy
    @grade.destroy
    head :no_content
  end

  private

  def set_grade
    @grade = current_school.grades.find(params[:id])
  end

  def check_grade_permission
    # Teachers can only manage grades from their subjects
    if current_user.teacher? && @grade.subject.teacher_id != current_user.id
      render json: { error: 'Você só pode gerenciar notas das suas disciplinas' }, status: :forbidden
    end
  end

  def grade_create_params
    params.require(:grade).permit(:student_id, :subject_id, scores: [])
  end

  def grade_json(grade)
    {
      id: grade.id.to_s,
      student_id: grade.student_id.to_s,
      student_name: grade.student.name,
      subject_id: grade.subject_id.to_s,
      subject_name: grade.subject.name,
      subject_code: grade.subject.code,
      scores: grade.scores,
      score_dates: grade.score_dates,
      average: grade.average,
      status: grade.status,
      school_id: grade.school_id.to_s,
      created_at: grade.created_at,
      updated_at: grade.updated_at
    }
  end
end
