class RegistrationsController < ApplicationController
  before_action :authorized_user
  
  def enroll
    event = Event.find(params[:event_id])
    user_id = current_user.id
    existing_registration = Registration.find_by(user_id: user_id, event_id: event.id)
  
    if existing_registration
      # If a registration already exists, check if it was previously deleted
      if existing_registration.deleted_at.nil?
        render json: { error: "You are already enrolled in this event" }, status: :unprocessable_entity
      else
        # Reactivate the existing registration by setting deleted_at to nil
        existing_registration.update(deleted_at: nil)
        render json: existing_registration, status: :ok
      end
    else
      # Create a new registration
      @registration = Registration.new(user_id: user_id, event_id: event.id)
      if @registration.save
        render json: @registration, status: :created
      else
        render json: @registration.errors, status: :unprocessable_entity
      end
    end
  end
  

  def unenroll
    event = Event.find(params[:event_id])
    user_id = current_user.id
    registration = Registration.find_by(event_id: event.id, user_id: user_id)
  
    if registration
      registration.update(deleted_at: Time.now)  # Set deleted_at timestamp
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
