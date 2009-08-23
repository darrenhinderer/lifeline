class EventsController < ApplicationController
  ActionView::Base.field_error_proc = proc { |input, instance| input }

  def new
    @event = Event.new(:start_date => Date.today)
    respond_to do |format|
      format.js {
        render(:update) { |page| page.replace :event, :partial => "add" }
      }
    end
  end

  def edit
    @event = Event.find(params[:id])
    respond_to do |format|
      format.js {
        render(:update) { |page| page.replace :event, :partial => "edit" }
      }
    end
  end

  def create
    @event = Event.new(params[:event])
    @user = User.find(session[:user_id])
    @event.user = @user
puts @event.start_date
puts @event.start_date.class
puts @event.start_date.to_time

    respond_to do |format|
      if @event.save
        @event = Event.new(:start_date => Date.today)
        format.html { redirect_to(@event) }
      else
        format.html { render :action => "new" }
      end
      format.js
    end
  end

  def update
    user = User.find(session[:user_id])
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        @event = Event.new(:start_date => Date.today)
        format.html { redirect_to(@event) }
        format.js {
          render(:update) { |page|
            page.replace :event, :partial => "add"
            page.call "loadEventsForUser", user.id
          }
        }
      else
        format.js {
          render(:update) { |page| page.replace :event, :partial => "edit" }
        }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    user = @event.user

    @event = Event.new(:start_date => Date.today)
    respond_to do |format|
      format.js {
        render(:update) { |page| 
          page.replace :event, :partial => "add" 
          page.call "loadEventsForUser", user.id
        }
      }
    end
  end
end
