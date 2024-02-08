class EventsController < ApplicationController
  before_action :authorized_admin, except: :index

  def index
    if current_user.role == 'admin'
      @past_events = Event.where('publish_date < ?', Date.today)
      @upcoming_events = Event.where('publish_date >= ?', Date.today)

      render json: { past_events: @past_events, upcoming_events: @upcoming_events }
    else
      @upcoming_events = Event.where('publish_date >= ?', Date.today)
      render json: @upcoming_events
    end
  end

  def show
    @event = Event.find(params[:id])
    render json: @event
  end

  def create
    @event = Event.new(new_params)
    if @event.save
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(new_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
  end
  private

  def new_params
    params.require(:event).permit(:title, :publish_date, :time, :venue, :description, :status)
  end

  def authorized_admin
    unless current_user.role == 'admin'
      render json: { message: 'You are not authorized' }, status: :unauthorized
    end
  end

end
