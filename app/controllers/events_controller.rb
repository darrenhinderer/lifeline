class EventsController < ApplicationController
  ActionView::Base.field_error_proc = proc { |input, instance| input }

  def index
    render :text => "nothing to see here, move along folks"
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    user = User.find(session[:user_id])
    @event.user_id = user.id

    respond_to do |format|
      if @event.save
        @data = {"events" => [@event.to_timeline]}.to_json
        @event = Event.new
        format.html { redirect_to(@event) }
        format.js   {
          render(:update) { |page| page.replace :add_event, :partial => "add" }
        }
      else
        format.js   {
          render(:update) { |page| page.replace :add_event, :partial => "add" }
        }
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
    end
  end
end
