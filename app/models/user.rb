class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :user_type, type: String, default: 'teacher'
  field :address, type: String

  belongs_to :school
  has_many :subjects, foreign_key: 'teacher_id', inverse_of: :teacher, dependent: :nullify

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :user_type, presence: true, inclusion: { in: %w[admin teacher] }
  validates :school, presence: true

  def admin?
    user_type == 'admin'
  end

  def teacher?
    user_type == 'teacher'
  end

  def generate_jwt
    payload = {
      user_id: id.to_s,
      school_id: school_id.to_s,
      user_type: user_type,
      exp: 48.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.secret_key_base || 'secret_key')
  end

  def self.decode_jwt(token)
    decoded = JWT.decode(token, Rails.application.credentials.secret_key_base || 'secret_key')[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
