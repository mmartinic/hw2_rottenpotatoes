class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    redirect = false
    
    order = params[:order]
    ratings = params[:ratings]
    
    if order.nil? and !session[:order].nil?
      order = session[:order]
      redirect = true
    end
    
    if ratings.nil? and !session[:ratings].nil?
      ratings = session[:ratings]
      redirect = true
    end
    
    if redirect
      flash.keep
      redirect_to movies_path(:order => order, :ratings => ratings)
    else
      session[:order] = order
      session[:ratings] = ratings
      
      if order == "title"
        @title_header_class = "hilite"
      elsif order == "release_date"
        @release_date_header_class = "hilite"
      end
      
      @ratings = ratings
      ratings_keys = @ratings.keys unless @ratings.nil?
      
      @all_ratings = {}
      Movie.get_ratings.each{|r| @all_ratings[r] = (!ratings_keys.nil? and ratings_keys.include?(r))}
      
      conditions = {:rating => ratings_keys} unless ratings_keys.nil?
      @movies = Movie.all(:conditions => conditions, :order => order)
    end
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
