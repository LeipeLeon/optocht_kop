class DeelnemersController < ApplicationController
  # GET /deelnemers
  # GET /deelnemers.xml
  
  before_filter :set_page_title, :except => [:create, :destroy]

  def index
    @deelnemers = Deelnemer.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deelnemers }
    end
  end

  # GET /deelnemers/1
  # GET /deelnemers/1.xml
  def show
    @deelnemer = Deelnemer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deelnemer }
    end
  end

  # GET /deelnemers/new
  # GET /deelnemers/new.xml
  def new
    @deelnemer = Deelnemer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deelnemer }
    end
  end

  # GET /deelnemers/1/edit
  def edit
    @deelnemer = Deelnemer.find(params[:id])
  end

  # POST /deelnemers
  # POST /deelnemers.xml
  def create
    @deelnemer = Deelnemer.new(params[:deelnemer])

    respond_to do |format|
      if @deelnemer.save
        flash[:notice] = 'Deelnemer was successfully created.'
        format.html { redirect_to(@deelnemer) }
        format.xml  { render :xml => @deelnemer, :status => :created, :deelnemer => @deelnemer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deelnemer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deelnemers/1
  # PUT /deelnemers/1.xml
  def update
    @deelnemer = Deelnemer.find(params[:id])

    respond_to do |format|
      if @deelnemer.update_attributes(params[:deelnemer])
        flash[:notice] = 'Deelnemer was successfully updated.'
        format.html { redirect_to(@deelnemer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deelnemer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deelnemers/1
  # DELETE /deelnemers/1.xml
  def destroy
    @deelnemer = Deelnemer.find(params[:id])
    @deelnemer.destroy

    respond_to do |format|
      format.html { redirect_to(deelnemers_url) }
      format.xml  { head :ok }
    end
  end

private
  def set_page_title
    @page_title = t('deelnemer.title')
  end
end
