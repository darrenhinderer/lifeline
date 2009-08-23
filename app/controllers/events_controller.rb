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
      format.js {
        render(:update) { |page| page.replace :event, :partial => "add" }
      }
    end
  end

  def edit
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js {
        render(:update) { |page| page.replace :event, :partial => "edit" }
      }
    end
  end

  def create
    @event = Event.new(params[:event])
    user = User.find(session[:user_id])
    @event.user = user
    @events = Event.all_public(user)

    respond_to do |format|
      if @event.save
        @data = {"events" => [@event.to_timeline]}.to_json
        @event = Event.new
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
        @event = Event.new
        format.html { redirect_to(@event) }
        format.js {
	  @data = {"events" => user.events}.to_json
          render(:update) { |page|
            page.replace :event, :partial => "add"
            page.call "reloadEvents", @data 
          }
        }
      else
        format.html { render :action => "edit" }
        format.js {
          render(:update) { |page| page.replace :event, :partial => "edit" }
        }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(user_path(session[:user_id])) }
    end
  end
end
