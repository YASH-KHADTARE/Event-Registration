class LoginController < ApplicationController
  skip_before_action :authorized, only: [:login]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def login
    @user = User.find_by(username: login_params[:username])
    if @user
      if @user.authenticate(login_params[:password])
        @token = encode_token(user_id: @user.id)
        render json: {
              user: UserSerializer.new(@user),
              token: @token
          }, status: :accepted
      else
        render json: { message: 'Incorrect password' }, status: :unauthorized
      end
    else
      render json: { message: 'Username not found' }, status: :not_found
    end
  end

  private

  def login_params
    params.require(:user).permit(:username , :password)
  end
  def handle_record_not_found(err)
    render json: {errors: err.record.errors.full_messages}, status: :unauthorized
  end

end
