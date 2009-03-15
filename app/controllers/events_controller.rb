class EventsController < ApplicationController
  layout 'application'
  
  # GET /events
  # GET /events.xml
  def index
    @events = Event.sort(params[:page], params[:sorted_by], session[:upcoming])
    create_map @ip_location

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end    
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  private
  
  def create_map(location)
    @map = GMap.new('map')
    @map.control_init(:large_map_3d => true,:map_type => true, :scale => true)
    @map.center_zoom_init([location[:latitude],location[:longitude]],8)
    @map.add_map_type_init(GMapType::G_PHYSICAL_MAP)
    @map.set_map_type_init(GMapType::G_PHYSICAL_MAP)
    get_upcoming_markers.each do |marker|
      @map.record_init @map.add_overlay(marker)
    end
  end
  
  def get_upcoming_markers
    markers = []
    Event.upcoming.each do |event|
      markers << GMarker.new([event.location.latitude, event.location.longitude], :info_window => "<div>#{event.group.name}</div><div>#{event.location.name}</div><div>#{Event.pretty_time(event.start_time)}</div>")
    end
    markers
  end

end
