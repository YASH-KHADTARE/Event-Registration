class RegistrationsController < ApplicationController
  before_action :authorized_user
  
  def enroll
    event = Event.find(params[:event_id])
    event_id = event[:id]
    user_id = current_user.id
    @registration = Registration.new(user_id: user_id, event_id: event_id)
    if @registration.save
      render json: @registration, status: :created
    else
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  def unenroll
    event = Event.find(params[:event_id])
    user_id = current_user.id
    registration = Registration.find_by(event_id: event.id, user_id: user_id)

    if registration
      registration.destroy
      render json: { message: 'Successfully unenrolled' }, status: :ok
    else
      render json: { message: 'You are not enrolled in this event' }, status: :not_found
    end
  end

  def my_events
    @events = current_user.events
    render json: @events
  end

  private
  def authorized_user
    unless current_user
      render json: {message: "Please login First"}, status: :unauthorized
    end
  end
end
