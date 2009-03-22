class SearchController < ApplicationController
  layout 'default'

  # GET /searches
  # GET /searches.xml  
  def index
    @query = params[:q]

    past = Time.parse(35.years.ago.strftime('%a, %d %b %Y %H:%M:%S %Z %z'))

    @search = Event.search(
      (@query || ""), 
      :page => (params[:page] || 1),
      :per_page => 10,
      # not working right now ... indexing the items in degrees and not radians, which is bad
      # :geo => [
      #   degrees_to_radians(@ip_location[:latitude].to_f),
      #   degrees_to_radians(@ip_location[:longitude].to_f)
      # ],
      # :with => { "@geodist" => 0.0..80467.2 }, # 50 miles, in meters
      :without => { :start_time => past..Time.now }, # A little hard-coded, but it works well enough for now.
      :order => "date ASC"
    )
    
    @locations = search_locations(@query)
    # @groups = Group.search(@query || "")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @search }
    end
  end
  
  def search_locations(query)
    Location.search(
      (query || ""),
      :geo => [
        degrees_to_radians(@ip_location[:latitude].to_f),
        degrees_to_radians(@ip_location[:longitude].to_f)
      ],
      :with => { "@geodist" => 0.0..80467.2 }, # 50 miles, in meters
      :order => "@geodist ASC"
    )
  end
  
  private
  def degrees_to_radians(degree) 
    degree * Math::PI / 180 
  end
end