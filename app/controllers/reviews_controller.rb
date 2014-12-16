class ReviewsController < ApplicationController
	before_action :confirm_logged_in
	before_action :set_movie
  before_action :set_review, only: [:update, :edit, :destroy]
  before_action :check_user, only: [:update, :edit, :destroy]

	  def new 
      @movie = Movie.find(params[:movie_id])
      @reviews = Review.where(movie_id: @movie.id)
      @reviews.each do |rev|
        if rev.user.username == session[:username]
          redirect_to(action: 'show', controller: 'movies', movie_id: @movie.id, id: @movie.id )
          return  
        end
      end
    end

  	def edit
  	end

  	def create
      @review = Review.new(review_params)
	    @review.user_id = session[:user_id]
	    @review.movie_id = @movie.id

  	  if @review.save
  	   	redirect_to(action: 'show', controller: 'movies', movie_id: @movie.id, id: @movie.id)
      else
	      render('new')
      end
	  end

  	def update
      if @review.update(review_params)
      	redirect_to(action: 'show', controller: 'movies', id: @movie.id)
      end
    end

    def destroy
      if @review.destroy
	      redirect_to(action: 'show', controller: 'movies', id: @movie.id)
	    end
   end

  	private

    def review_params
      params.require(:review).permit(:comment, :rating)
    end

    def set_movie
      @movie = Movie.find(params[:movie_id])
    end

    def set_review
      @review = Review.find(params[:id])
    end

    def check_user
      unless (@review.user.username == session[:username] || @review.user.admin?)
        redirect_to(action: 'show', controller: 'movies', id: @movie.id)
      end
    end
end
