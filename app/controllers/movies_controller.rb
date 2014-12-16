require 'open-uri'

class MoviesController < ApplicationController
  
  before_action :confirm_logged_in

  def dashboard
  end

  def list
    doc = Nokogiri::HTML(open("http://mangalore.ghoomo.com/"))
    @movie = []
    doc.xpath('//div[contains(@id,"txtHint")]/ul/li/span[contains(@class,"item-title")]').each do |node|
      @movie << node.text
      @temp = Movie.new
      @temp.name = node.text
      @temp.save
    end
    @movies = Movie.all
  end

  def show
    @flag = 0
    @movie = Movie.find(params[:id])
    @reviews = Review.where(movie_id: @movie.id).order("created_at DESC")
    if @reviews.blank?
      @avg_rating = 0
    else
      @avg_rating = @reviews.average(:rating).round(2)
    end
  end

end
