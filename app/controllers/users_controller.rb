class UsersController < ApplicationController
  before_action :authorized_admin, only: [:search, :show]
  skip_before_action :authorized, only:[:create]
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

  def create 
    @user = User.new(create_params)
    if @user.save
      @token = encode_token(user_id: @user.id)
      render json:  { user: @user, token: @token}
    else
      render json: @user.errors.full_messages , status: 422
    end  
  end

  def search
    username_query = params[:username]
    email_query = params[:email]
    full_name_query = params[:full_name]
  
    @users = User.all
  
    @users = @users.where("username LIKE ?", "%#{username_query}%") if username_query.present?
    @users = @users.where("email LIKE ?", "%#{email_query}%") if email_query.present?
    @users = @users.where("full_name LIKE ?", "%#{full_name_query}%") if full_name_query.present?
  
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  def enrolled_events
    debugger
    @user = User.find(params[:id])
    all_registers = Registration.where(user_id: @user.id)
    event_ids = all_registers.pluck(:event_id)
    events = Event.where(id:event_ids)
    render json: events
  end


  private

  def create_params
    params.require(:user).permit(:username, :full_name, :password, :email)
  end

  def handle_invalid_record(err)
    render json: {errors: err.record.errors.full_messages}, status: :unprocessable_entity
  end

  def authorized_admin
    unless current_user.role == 'admin'
      render json: { message: 'You are not authorized' }, status: :unauthorized
    end
  end
end
