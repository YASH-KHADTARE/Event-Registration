  class EventsController < ApplicationController
    before_action :authorized_admin, except: [:index, :search]

    def index
      if current_user.role == 'admin'
        @past_events = Event.where('publish_date < ?', Date.today)
        @upcoming_events = Event.where('publish_date >= ?', Date.today)

        past_events_with_members = @past_events.map { |event| event_with_members(event) }
        upcoming_events_with_members = @upcoming_events.map { |event| event_with_members(event) }

        render json: { past_events: past_events_with_members, upcoming_events: upcoming_events_with_members }
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

    def search
      title_query = params[:title]
      date_query = params[:date]
      time_query = params[:time]
      type_query = params[:type]
    
      @events = Event.all
    
      @events = @events.where('title LIKE ?', "%#{title_query}%") if title_query.present?
      @events = @events.where(publish_date: date_query) if date_query.present?
      @events = @events.where(time: time_query) if time_query.present?
      @events = @events.where(event_type: type_query) if type_query.present?
    
      render json: @events
    end
    

    def members
      @event = Event.find(params[:id])
      all_registers = Registration.where(event_id: @event.id)
      user_ids = all_registers.pluck(:user_id)
      users = User.where(id: user_ids)
      render json: users      
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

    def event_with_members(event)
      {
        event: event,
        members_count: event.registrations.count
      }
    end

  end
