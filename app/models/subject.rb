class Subject
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :code, type: String
  field :number_of_grades, type: Integer, default: 1
  field :passing_average, type: Float, default: 7.0
  field :recovery_average, type: Float, default: 5.0

  belongs_to :school
  belongs_to :teacher, class_name: 'User', inverse_of: :subjects
  has_many :grades, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { scope: :school_id }
  validates :number_of_grades, presence: true, 
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }
  validates :passing_average, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :recovery_average, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :school, presence: true
  validates :teacher, presence: true
  validate :teacher_must_be_teacher_type

  index({ school_id: 1, code: 1 }, { unique: true })

  private

  def teacher_must_be_teacher_type
    if teacher.present? && !teacher.teacher? && !teacher.admin?
      errors.add(:teacher, 'must be a teacher or admin')
    end
  end
end
