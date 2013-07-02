class StartupsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json {
        startups = Startup.is_published.all

        venues = startups.uniq{|startup| startup.coordinates.to_a}.inject([]) {|memo, startup|
          hsh = {
            lat: startup.coordinates.last,
            lng: startup.coordinates.first,
            name: startup.name
          }
          memo << hsh
          memo
        }

        render :json => venues.to_json
      }
    end
  end

  def new
  	@startup = Startup.new
  end

  def create
  	@startup = Startup.new create_params
    @startup.coordinates = Geocoder.coordinates(@startup.address)

  	if @startup.save
  		render :action => "thanks"
  	else
  		render :action => "new"
  	end
  end

  protected

  def create_params
  	params.require(:startup).permit(:name, :url, :street, :zip_code, :city, :email, :description, :logo)
  end
end
