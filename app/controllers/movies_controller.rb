class MoviesController < ApplicationController
  
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def sort_by_title
    # to keep app RESTfull add custom routes special resource request
    # they wanted to use RESTfull route for sorting ..and do redirect to movies#index, i think
    # match "/movies/sortbt" => "movies#sort_by_title" // routes.rb
    session[:userfilter] = {} if session[:userfilter] == nil
    # Add any new params to session and delete unwanted param
    if params[:titlesort] and params[:hilite] then
      session[:userfilter]["bgcolor_tilte"] = "hilite"
      session[:userfilter]["titlesort"] = params[:titlesort]
      session[:userfilter]["hilite"] = params[:hilite]
      session[:userfilter].delete("rdatesort") if session[:userfilter]["rdatesort"] != nil
      session[:userfilter].delete("bgcolor_rdate") if session[:userfilter]["bgcolor_rdate"] != nil
      flash[:notice] = "Movies was sorted by Title successfully."
    end
    redirect_to movies_path
  end
  
  def sort_by_release_date
    # to keep app RESTfull add custom routes special resource request
    session[:userfilter] = {} if session[:userfilter] == nil
    # Add any new params to session and delete unwanted param
    if params[:rdatesort] then
      session[:userfilter]["rdatesort"] = params[:rdatesort]
      session[:userfilter]["bgcolor_rdate"] = "hilite"
      session[:userfilter].delete("titlesort") if session[:userfilter]["titlesort"] != nil
      session[:userfilter].delete("bgcolor_tilte") if session[:userfilter]["bgcolor_tilte"] != nil
      flash[:notice] = "Movies was sorted by Release Date successfully."
    end
    redirect_to movies_path
  end
  
  def filter_by_rating
    session[:userfilter] = {} if session[:userfilter] == nil
    if params[:ratings] then
      # ...But, wait, this breaks MVC principle. View should not touch params at all. 
      # All these works should be done at controller level. What if the params is incorrect?
      # You need controller to respond that, instead of passing that responsibility to view.
      session[:userfilter]["ratings"] = params[:ratings]
      flash[:notice] = "Movies was filtered by Raiting successfully."
    end
    redirect_to movies_path
  end

  def index
    # byebug
    # @movie = Movie.new    get the movie instance and work localy
    @all_ratings = Movie.ratings
    @checked = Hash.new("1")  # store hash with default values of 1

    session[:userfilter] = {} if session[:userfilter] == nil
    @movies = Movie.all

    # Exec query based on params stored in session
    if session[:userfilter] != nil and !session[:userfilter].empty? then
      # collect all params and build view using them
      @movies = Movie.session_prev_state(session[:userfilter])
      @bgcolor_title = session[:userfilter]["bgcolor_tilte"] if session[:userfilter]["bgcolor_tilte"] != nil
      @bgcolor_rdate = session[:userfilter]["bgcolor_rdate"] if session[:userfilter]["bgcolor_rdate"] != nil
      @checked = session[:userfilter]["ratings"] if session[:userfilter]["ratings"] != nil
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
