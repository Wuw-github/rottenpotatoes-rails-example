class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    need_redirect = false
    if params[:ratings].nil? and !session[:ratings_to_show].nil?
      params[:ratings] = Hash.new
      session[:ratings_to_show].each do |rate|
        params[:ratings][rate] = "1"
      end
      need_redirect = true
    end
    if params[:sort].nil? and !session[:sort].nil?
      params[:sort] = session[:sort]
      need_redirect = true
    end

    if need_redirect
      redirect_to movies_path(params)
    end

    @ratings_to_show = params[:ratings].nil? ? (session[:ratings_to_show].nil? ? Movie.all_ratings : session[:ratings_to_show]) : params[:ratings].keys
    @sort = params[:sort].nil? ? session[:sort] : params[:sort]
    session[:ratings_to_show] = @ratings_to_show
    session[:sort] = @sort

    @movies = Movie.with_ratings(@ratings_to_show)
    if @sort == "release_date"
      @movies = @movies.sort_by{ |movie| movie.release_date}
    elsif @sort == "title"
      @movies = @movies.sort_by{ |movie| movie.title}
    end
    @all_ratings = Movie.all_ratings
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
