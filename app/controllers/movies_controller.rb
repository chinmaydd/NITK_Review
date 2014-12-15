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
    end
  end

end
