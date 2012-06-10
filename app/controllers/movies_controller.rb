class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    order = params[:order]
    if order == "title"
      @title_header_class = "hilite"
    elsif order == "release_date"
      @release_date_header_class = "hilite"
    end
    
    @ratings_map = params[:ratings]
    ratings = @ratings_map.keys unless @ratings_map.nil?
    
    @all_ratings = {}
    Movie.get_ratings.each{|r| @all_ratings[r] = (!ratings.nil? and ratings.include?(r))}
    
    conditions = {:rating => ratings} unless ratings.nil?
    @movies = Movie.all(:conditions => conditions, :order => order)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
