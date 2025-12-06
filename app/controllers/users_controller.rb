class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :login]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authorize_admin!, only: [:destroy, :index]

  def index
    users = current_school.users
    render json: users.map { |u| user_json(u) }, status: :ok
  end

  def show
    render json: user_json(@user), status: :ok
  end

  def create
    user = User.new(user_params)
    
    if user.save
      token = user.generate_jwt
      render json: { user: user_json(user), token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = user.generate_jwt
      render json: { user: user_json(user), token: token }, status: :ok
    else
      render json: { error: 'E-mail ou senha inválidos' }, status: :unauthorized
    end
  end

  def me
    render json: user_json(current_user), status: :ok
  end

  def update
    # Only admin can update other users, users can update themselves
    unless current_user.admin? || @user.id == current_user.id
      return render json: { error: 'Acesso negado' }, status: :forbidden
    end

    # Teachers cannot change user_type
    if current_user.teacher? && user_params[:user_type].present?
      return render json: { error: 'Professores não podem alterar o tipo de usuário' }, status: :forbidden
    end

    if @user.update(update_user_params)
      render json: user_json(@user), status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = if params[:id] == 'me' || !params[:id]
      current_user
    elsif current_user.admin?
      current_school.users.find(params[:id])
    else
      current_user
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_type, :address, :school_id)
  end

  def update_user_params
    allowed = [:name, :email, :address]
    allowed += [:user_type, :school_id] if current_user.admin?
    allowed << :password if params[:user][:password].present?
    allowed << :password_confirmation if params[:user][:password_confirmation].present?
    
    params.require(:user).permit(*allowed)
  end

  def user_json(user)
    {
      id: user.id.to_s,
      name: user.name,
      email: user.email,
      user_type: user.user_type,
      address: user.address,
      school_id: user.school_id.to_s,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
