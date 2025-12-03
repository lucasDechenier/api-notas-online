class Student
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :registration_number, type: String
  field :phone, type: String

  belongs_to :school
  has_many :grades, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :registration_number, presence: true, uniqueness: { scope: :school_id }
  validates :school, presence: true

  index({ school_id: 1, registration_number: 1 }, { unique: true })
end
