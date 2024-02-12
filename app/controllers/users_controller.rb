class UsersController < ApplicationController
  before_action :authorized_admin, only: [:search]
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
    query = params[:query]
    if query.present?
      @users = User.where("full_name LIKE ?", "%#{query}%")
      render json: @users
    else
      render json: {message: "Please Provide a search query", status: :bad_request} 
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
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
