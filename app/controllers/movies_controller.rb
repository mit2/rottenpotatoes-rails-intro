class MoviesController < ApplicationController
  
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # byebug
    # @movie = Movie.new    get the movie instance and work localy
    @all_ratings = Movie.ratings
    @checked = Hash.new("1")  # store hash with default values of 1

    if session[:usrsettings] != nil and !session[:usrsettings].empty? and params.size == 2 # url with no additional params
      # collect all params and build view using them
      @movies = Movie.session_prev_state(session[:usrsettings])
      @bgcolor = session[:usrsettings]["bgcolor"]
      @checked = session[:usrsettings]["ratings"] if session[:usrsettings]["ratings"] != nil
    else 
      session[:usrsettings] = {} if session[:usrsettings] == nil  ||  !session[:usrsettings].empty? # clean session prev state to store new state
      # Sorting by column
      if params[:titlesort] and params[:hilite]
        @movies = Movie.order(:title)
        @bgcolor = "hilite"
        session[:usrsettings]["bgcolor"] = "hilite"
        session[:usrsettings]["titlesort"] = params[:titlesort]
        session[:usrsettings]["hilite"] = params[:hilite]
      elsif params[:rdatesort]
        @movies = Movie.order(:release_date)
        session[:usrsettings]["rdatesort"] = params[:rdatesort]
      elsif params[:ratings]
        # ...But, wait, this breaks MVC principle. View should not touch params at all. 
        # All these works should be done at controller level. What if the params is incorrect?
        # You need controller to respond that, instead of passing that responsibility to view.
        
        @movies = Movie.with_ratings params[:ratings].keys
        @checked = params[:ratings]
        session[:usrsettings]["ratings"] = params[:ratings]
      else
        @movies = Movie.all
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
