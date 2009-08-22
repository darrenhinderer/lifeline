class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @users = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @users = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1/edit
  def edit
    @users = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @users = User.new(params[:users])

    respond_to do |format|
      if @users.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@users) }
        format.xml  { render :xml => @users, :status => :created, :location => @users }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @users.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @users = User.find(params[:id])

    respond_to do |format|
      if @users.update_attributes(params[:users])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@users) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @users.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @users = User.find(params[:id])
    @users.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
