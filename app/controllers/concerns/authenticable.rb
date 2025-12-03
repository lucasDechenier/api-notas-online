module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    attr_reader :current_user
  end

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    
    unless token
      render json: { error: 'Token not provided' }, status: :unauthorized
      return
    end

    decoded = JsonWebToken.decode(token)
    
    unless decoded
      render json: { error: 'Invalid or expired token' }, status: :unauthorized
      return
    end

    @current_user = User.find(decoded[:user_id])
    @current_school = School.find(decoded[:school_id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: 'User not found' }, status: :unauthorized
  end

  def current_school
    @current_school
  end

  def authorize_admin!
    unless @current_user&.admin?
      render json: { error: 'Access denied. Admin only.' }, status: :forbidden
    end
  end

  def authorize_teacher_or_admin!
    unless @current_user&.admin? || @current_user&.teacher?
      render json: { error: 'Access denied' }, status: :forbidden
    end
  end
end
