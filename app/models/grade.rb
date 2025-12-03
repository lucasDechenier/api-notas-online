class Grade
  include Mongoid::Document
  include Mongoid::Timestamps

  field :scores, type: Array, default: []
  field :score_dates, type: Array, default: []
  field :average, type: Float

  belongs_to :school
  belongs_to :student
  belongs_to :subject

  validates :school, presence: true
  validates :student, presence: true
  validates :subject, presence: true
  validate :student_and_subject_belong_to_same_school
  validate :unique_grade_per_student_per_subject
  validate :scores_count_matches_subject
  validate :all_scores_are_valid

  before_save :calculate_average

  index({ student_id: 1, subject_id: 1 }, { unique: true })

  def add_score(score, date = Time.current)
    if scores.length >= subject.number_of_grades
      errors.add(:scores, "cannot exceed #{subject.number_of_grades} grades")
      return false
    end

    self.scores << score.to_f
    self.score_dates << date
    calculate_average
    true
  end

  def update_score(index, score, date = Time.current)
    if index < 0 || index >= scores.length
      errors.add(:scores, 'invalid score index')
      return false
    end

    self.scores[index] = score.to_f
    self.score_dates[index] = date
    calculate_average
    true
  end

  def status
    return 'incomplete' if average.nil? || scores.length < subject.number_of_grades

    if average >= subject.passing_average
      'approved'
    elsif average >= subject.recovery_average
      'recovery'
    else
      'failed'
    end
  end

  private

  def calculate_average
    return if scores.empty?
    
    self.average = scores.sum / scores.length.to_f
  end

  def student_and_subject_belong_to_same_school
    if student && subject && student.school_id != subject.school_id
      errors.add(:base, 'student and subject must belong to the same school')
    end

    if school_id && student && student.school_id != school_id
      errors.add(:base, 'student must belong to the grade school')
    end

    if school_id && subject && subject.school_id != school_id
      errors.add(:base, 'subject must belong to the grade school')
    end
  end

  def unique_grade_per_student_per_subject
    return unless student_id && subject_id

    existing = Grade.where(student_id: student_id, subject_id: subject_id)
    existing = existing.where(:id.ne => id) if persisted?

    if existing.exists?
      errors.add(:base, 'only one grade record per student per subject is allowed')
    end
  end

  def scores_count_matches_subject
    return unless subject && scores.present?

    if scores.length > subject.number_of_grades
      errors.add(:scores, "cannot exceed #{subject.number_of_grades} grades for this subject")
    end
  end

  def all_scores_are_valid
    return unless scores.present?

    scores.each_with_index do |score, index|
      unless score.is_a?(Numeric) && score >= 0 && score <= 10
        errors.add(:scores, "score at position #{index + 1} must be between 0 and 10")
      end
    end
  end
end
