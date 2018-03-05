require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @rand_array=[]
    alphabet = ("A".."Z").to_a
    10.times do
      @rand_array << alphabet.sample
    end
  end

  def score
    # @total = 0
    # session[:total_score] = 0
    if session[:total_score].nil?
      session[:total_score] = 0
    end
    @score = 0
    @word = params[:word].upcase
    @rand_array = params[:rand_array]
    if @word.split("").all? do |letter|
        @rand_array.include?(letter) && @word.count(letter) <= @rand_array.count(letter)
      end
      url_result = "https://wagon-dictionary.herokuapp.com/#{@word}"
      serialized_results = open(url_result).read
      results = JSON.parse(serialized_results)
      if results["found"] == true
        # if word is a valid English word, increment score
        @score = @word.length
        @message = "Good answer!"
        session[:total_score] += @score
      else
        @message = "invalid answer!"
      end
    else
      @message = "invalid answer!"
    end
    @total = session[:total_score]
  end
end
