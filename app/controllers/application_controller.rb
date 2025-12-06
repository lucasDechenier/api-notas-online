class ApplicationController < ActionController::API
  include Authenticable

  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found
  rescue_from Mongoid::Errors::Validations, with: :unprocessable_entity

  private

  def not_found
    render json: { error: 'Registro não encontrado' }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
