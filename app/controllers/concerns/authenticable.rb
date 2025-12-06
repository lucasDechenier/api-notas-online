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
      render json: { error: 'Token não fornecido' }, status: :unauthorized
      return
    end

    decoded = JsonWebToken.decode(token)
    
    unless decoded
      render json: { error: 'Token inválido ou expirado' }, status: :unauthorized
      return
    end

    @current_user = User.find(decoded[:user_id])
    @current_school = School.find(decoded[:school_id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: 'Usuário não encontrado' }, status: :unauthorized
  end

  def current_school
    @current_school
  end

  def authorize_admin!
    unless @current_user&.admin?
      render json: { error: 'Acesso negado. Apenas administradores.' }, status: :forbidden
    end
  end

  def authorize_teacher_or_admin!
    unless @current_user&.admin? || @current_user&.teacher?
      render json: { error: 'Acesso negado' }, status: :forbidden
    end
  end
end
